class PivotalStatusesController < ApplicationController
  post '/event_handler' do
    @github_client ||= GithubClient.new
    @payload = JSON.parse(params[:payload])
    case request.env['HTTP_X_GITHUB_EVENT']
    when 'pull_request'
      if %w(opened reopened).include? @payload['action']
        @github_client.process_pull_request(@payload['pull_request'])
      end
    end
  end
end
