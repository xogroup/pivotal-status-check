require_relative '../spec_helper'

describe 'GithubClient' do
  PIVOTAL_TRACKER_TOKEN = '1234567'.freeze

  context '#process_pull_request' do
    let(:pull_request) do
      JSON.parse(File.read('spec/fixtures/pull_request_payload.json'))
    end

    let(:subject) { GithubClient.new }
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
            kind_of(Hash),
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
            kind_of(Hash),
            state: 'failure',
            options: kind_of(Hash)

          subject.process_pull_request(pull_request)
        end
      end
    end
  end
end
