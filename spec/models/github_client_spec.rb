
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'GithubClient' do
  PIVOTAL_TRACKER_TOKEN = '1234567'
  GITHUB_REPO = 'org/repo'

  let(:subject) { GithubClient.new }
  let(:pull_request) do
    JSON.parse(File.read('spec/fixtures/pull_request_payload.json'))
  end

  context '#process_pull_request' do
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
            pull_request: pull_request,
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
            pull_request: pull_request,
            state: 'failure',
            options: kind_of(Hash)

          subject.process_pull_request(pull_request)
        end
      end
    end
  end
  context '#set_status' do
    it 'handles a pull request argument' do
      allow_any_instance_of(PivotalClient)
        .to receive(:accepted?).and_return true

      expect_any_instance_of(Octokit::Client).to receive(:create_status).with \
        'pivotal-status-check',
        'ba337a3b508599d9dfd28420eff2a8d42a90072f',
        'pending',
        context: 'Pivotal Acceptance State'

      subject.set_status(pull_request: pull_request, state: 'pending')
    end

    it 'handles specific name and sha arguments' do
      allow_any_instance_of(PivotalClient)
        .to receive(:accepted?).and_return true

      expect_any_instance_of(Octokit::Client).to receive(:create_status).with \
        'branch/thing',
        '123',
        'pending',
        context: 'Pivotal Acceptance State'

      subject.set_status(repo_name: 'branch/thing', sha: '123', state: 'pending')
    end
  end
  context '#find_branch' do
    let(:pull_request) do
      JSON.parse \
        File.read('spec/fixtures/pull_request_payload.json'),
        object_class: OpenStruct
    end

    it 'returns the branch that matches the pivotal story id' do
      allow_any_instance_of(Octokit::Client)
        .to receive(:pull_requests).and_return [pull_request]

      expect(subject.find_branch(pivotal_tracker_id: '123')).to_not be_nil
    end

    it 'returns nil if nothing is found' do
      allow_any_instance_of(Octokit::Client)
        .to receive(:pull_requests).and_return [pull_request]

      expect(subject.find_branch(pivotal_tracker_id: '456')).to be nil
    end
  end
end
