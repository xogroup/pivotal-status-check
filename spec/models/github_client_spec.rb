require_relative '../spec_helper'

describe 'GithubClient' do
  let(:subject) { GithubClient.new }

  context '#process_pull_request' do
    describe 'When the Pivotal State' do
      describe 'is accepted' do
        let(:pull_request) do
          {
            'head' => {
              'ref' => 'feature/sample_branch_123'
            }
          }
        end

        let(:pivotal_client) { PivotalClient.new(pull_request) }
        let(:tracker_api) { double tracker_api }

        before(:each) do
          allow(PivotalClient).to receive(:new).with(pull_request).and_return(pivotal_client)
          allow(TrackerApi::Client).to receive(:new).with(token).and_return(tracker_api)
          allow(TrackerApi::Endpoints::Story).to receive_message_chain(:new, :get).and_return(TrackerApi::Resources::Story.new())
          allow(PivotalClient).to receive(:accepted?).and_return true
          allow(PivotalClient).to receive_message_chain(:project, :story) { pivotal_client }
        end
        it 'sets the status to success' do
          subject.process_pull_request(pull_request)
          expect(subject).to have_received(:set_status).with(
            {},
            state: 'success',
            options: {}
          )
        end
      end
      describe 'is not accepted' do
        it 'sets the status to failure' do
        end
      end
    end
  end
end
