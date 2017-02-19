class PivotalStatusesController < ApplicationController
  before do
    @github ||= Octokit::Client.new(access_token: GITHUB_ACCESS_TOKEN)
    @pivotal ||= PivotalClient.new(project_id: PIVOTAL_PROJECT_ID)
  end

  post '/event_handler' do
    @payload = JSON.parse(params[:payload])
    case request.env['HTTP_X_GITHUB_EVENT']
    when 'pull_request'
      if @payload['action'] == 'opened'
        process_pull_request(@payload['pull_request'])
      end
    end
  end

  helpers do
    def process_pull_request(pull_request)
      @client.create_status(pull_request['base']['repo']['full_name'], pull_request['head']['sha'], 'pending')
      puts pull_request.keys
      # @pivotal.accepted?()
      @client.create_status(pull_request['base']['repo']['full_name'], pull_request['head']['sha'], 'success')
      puts 'Pull request processed!'
    end
  end
end
