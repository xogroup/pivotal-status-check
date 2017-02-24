require_relative '../spec_helper'

def app
  PivotalStatusesController
end

describe PivotalStatusesController do
  let(:payload) { File.read('spec/fixtures/webhook_pr_payload.json') }
  describe 'When the Pivotal State' do
    describe 'is accepted' do
      before(:each) do
        allow_any_instance_of(GithubClient).to receive(:set_status).and_return({})
      end
      it 'sets the status to success' do
        header 'X-GitHub-Event', 'pull_request'
        post '/event_handler', payload: payload
        expect(last_response.status).to eq(200)
      end
    end
    describe 'is not accepted' do
      it 'sets the status to failure' do
        header 'X-GitHub-Event', 'pull_request'
        post '/event_handler', payload: payload
        expect(last_response.status).to eq(404)
      end
    end
  end
end
