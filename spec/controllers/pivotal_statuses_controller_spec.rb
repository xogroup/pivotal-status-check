require_relative '../spec_helper'

def app
  PivotalStatusesController
end

describe PivotalStatusesController do
  let(:github_payload) { File.read('spec/fixtures/webhook_pr_payload.json')}
  let(:pivotal_payload) { File.read('spec/fixtures/pivotal_activity_webhook.json')}
  let(:response) { JSON.parse(last_response.body) }

  describe 'When the Pivotal State' do
    describe 'is accepted' do
      before do
        allow_any_instance_of(GithubClient).to receive(:set_status)
        allow_any_instance_of(GithubClient).to receive(:process_pull_request)
          .and_return(state: 'success')
      end
      it 'sets the status of the pull request to success' do
        header 'X-GitHub-Event', 'pull_request'
        post '/accepted_status_check', github_payload
        expect(response['state']).to eq 'success'
      end

      it 'sends the payload about the accepted story' do
        post '/accepted', pivotal_payload
        expect(response).to be success
        # expect(false).to be true
      end
    end
    describe 'is not accepted' do
      before do
        allow_any_instance_of(GithubClient).to receive(:set_status)
        allow_any_instance_of(GithubClient).to receive(:process_pull_request)
          .and_return(state: 'failure')
      end
      it 'sets the status of the pull request to failure' do
        header 'X-GitHub-Event', 'pull_request'
        post '/accepted_status_check', github_payload
        expect(response['state']).to eq 'failure'
      end
    end
  end
end
