class PivotalStatusesController < ApplicationController
  post '/accepted_status_check' do
    @github_client ||= GithubClient.new
    @payload = JSON.parse(request.body.read)
    case request.env['HTTP_X_GITHUB_EVENT']
    when 'pull_request'
      if %w(opened reopened synchronize).include? @payload['action']
        @github_client.set_status(pull_request: @payload['pull_request'], state: 'pending')
        json @github_client.process_pull_request(@payload['pull_request'])
      end
    end
  end

  post '/accepted' do
    @github_client ||= GithubClient.new
    @payload = JSON.parse(request.body.read)

    story_id = @payload['primary_resources'].first['id']
    branch = @github_client.find_branch(story_id)

    if @payload['highlight'] == 'accepted'
      json @github_client.set_status \
        name: branch[:name],
        sha: branch[:sha],
        state: 'success'
    else
      json @github_client.set_status \
        name: branch[:name],
        sha: branch[:sha],
        state: 'failure'
    end
  end
end
