require_relative '../spec_helper'

def app
  PivotalStatusesController
end

describe PivotalStatusesController do
  let(:payload) { File.open mock_payload }
  it 'responds with a 200' do
    post '/event_handler'
    expect(last_response.status).to eq(200)
  end

  describe 'When the Pivotal State' do
    describe 'is accepted' do
      it 'sets the status to success' do
        post '/event_handler'
      end
    end
    describe 'is not accepted' do
      it 'sets the status to failure' do
        post '/event_handler'
      end
    end
  end
end
