require_relative '../spec_helper'

def app
  PivotalStatusesController
end

describe PivotalStatusesController do
  let(:payload) { File.read('spec/fixtures/webhook_pr_payload.json') }
  describe 'When the Pivotal State' do
    describe 'is accepted' do
      before do
        allow_any_instance_of(GithubClient).to receive(:set_status)
        allow_any_instance_of(GithubClient).to receive(:process_pull_request)
          .and_return(state: 'success')
      end
      it 'sets the status to success' do
        header 'X-GitHub-Event', 'pull_request'
        post '/event_handler', payload: payload
        expect(last_response.body).to include('success')
      end
    end
    describe 'is not accepted' do
      before do
        allow_any_instance_of(GithubClient).to receive(:set_status)
        allow_any_instance_of(GithubClient).to receive(:process_pull_request)
          .and_return(state: 'failure')
      end
      it 'sets the status to failure' do
        header 'X-GitHub-Event', 'pull_request'
        post '/event_handler', payload: payload
        expect(last_response.body).to include('failure')
      end
    end
  end
end
