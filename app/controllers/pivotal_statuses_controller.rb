class PivotalStatusesController < ApplicationController
  before do
    @github ||= GithubClient.new
  end

  post '/event_handler' do
    @payload = JSON.parse(params[:payload])
    case request.env['HTTP_X_GITHUB_EVENT']
    when 'pull_request'
      if %w(opened reopened).include? @payload['action']
        process_pull_request(@payload['pull_request'])
      end
    end
  end

  helpers do
    def process_pull_request(pull_request)
      @pivotal = PivotalClient.new(pull_request)

      @github.set_state(pull_request, state: 'pending')
      @github.set_state(pull_request, state: 'error') unless @pivotal

      @github.set_pivotal_state(pull_request, pivotal_project: @pivotal)
      puts 'Pull request processed!'
    end


  end
end
