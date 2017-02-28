require_relative '../spec_helper'

def app
  PivotalStatusesController
end

describe PivotalStatusesController do
  let(:github_payload) { File.read('spec/fixtures/webhook_pr_payload.json')}
  let(:pivotal_accepted_payload) { File.read('spec/fixtures/pivotal_accepted_payload.json')}
  let(:pivotal_failure_payload) { File.read('spec/fixtures/pivotal_failure_payload.json')}
  let(:response) { JSON.parse(last_response.body) }
  let(:branch) do
    {
      name: 'feature/some_branch_123',
      commit:
      {
        sha: '6a5ba717d80a8012b26b1c27887f26bd324c9633',
        url: 'github.com'
      }
    }
  end

  describe 'When the Pivotal State' do
    describe 'is accepted' do
      describe 'and the Github webhook fires' do
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
      end

      describe 'and the Pivotal webhook fires' do


        before do
          allow_any_instance_of(GithubClient).to receive(:find_branch)
            .and_return branch
          allow_any_instance_of(GithubClient).to receive(:set_status)
            .and_return(state: 'success')
        end

        it 'sets the status of the pull request to success' do
          post '/accepted', pivotal_accepted_payload
          expect(response['state']).to eq 'success'
        end
      end
    end
    describe 'is not accepted' do
      describe 'and the Github webhook fires' do
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
      describe 'and the Pivotal webhook fires' do
        before do
          allow_any_instance_of(GithubClient).to receive(:find_branch)
            .and_return branch
          allow_any_instance_of(GithubClient).to receive(:set_status)
            .and_return(state: 'failure')
        end

        it 'sets the status of the pull request to success' do
          post '/accepted', pivotal_failure_payload
          expect(response['state']).to eq 'failure'
        end
      end
    end
  end
end
