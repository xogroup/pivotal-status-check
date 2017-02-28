require_relative '../spec_helper'

describe 'GithubClient' do
  PIVOTAL_TRACKER_TOKEN = '1234567'.freeze

  let(:subject) { GithubClient.new }

  context '#process_pull_request' do
    let(:pull_request) do
      JSON.parse(File.read('spec/fixtures/pull_request_payload.json'))
    end
    let(:project) { double('project', story: story) }
    let(:story) { double('story', url: '') }

    before(:each) do
      allow_any_instance_of(TrackerApi::Client).to receive(:project)
        .and_return(project)
    end

    describe 'When the Pivotal State' do
      describe 'is accepted' do
        it 'sets the status to success' do
          allow_any_instance_of(PivotalClient)
            .to receive(:accepted?).and_return true

          expect(subject).to receive(:set_status).with \
            'pivotal-status-check',
            'ba337a3b508599d9dfd28420eff2a8d42a90072f',
            state: 'success',
            options: kind_of(Hash)

          subject.process_pull_request(pull_request)
        end
      end
      describe 'is not accepted' do
        it 'sets the status to failure' do
          allow_any_instance_of(PivotalClient)
            .to receive(:accepted?).and_return false

          expect(subject).to receive(:set_status).with \
            'pivotal-status-check',
            'ba337a3b508599d9dfd28420eff2a8d42a90072f',
            state: 'failure',
            options: kind_of(Hash)

          subject.process_pull_request(pull_request)
        end
      end
    end
  end
  context '#find_branch' do
    let(:branches) do
      [
        {
          name: 'feature/some_branch_123',
          commit:
          {
            sha: '6a5ba717d80a8012b26b1c27887f26bd324c9633',
            url: 'github.com'
          }
        }
      ]
    end

    before do
      allow_any_instance_of(GithubClient)
        .to receive(:branches).and_return branches
    end

    it 'returns the branch that matches the pivotal story id' do
      subject.find_branch(pivotal_tracker_id: '123')
    end
  end
end
