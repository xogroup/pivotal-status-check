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
        before(:each) do
          allow(PivotalClient).to receive(:new).with(pull_request)
          allow(PivotalClient).to receive(:accepted?).and_return true
          project = allow(PivotalClient).to receive(:project).with(123)
          allow(PivotalClient).to receive_message_chain(:project, :story).and_return {}
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
