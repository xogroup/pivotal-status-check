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

    story_id = @payload['primary_resources'].first['id'].to_s
    branch = @github_client.find_branch(pivotal_tracker_id: story_id)
    return json error: 'No branch with that Story ID' if branch.nil?

    if @payload['highlight'] == 'accepted'
      @github_client.set_status \
        repo_name: branch.base.repo.full_name,
        sha: branch.head.sha,
        state: 'success'

      json state: 'success', message: "#{branch.head.ref} state changed to success"
    else
      @github_client.set_status \
        repo_name: branch.base.repo.full_name,
        sha: branch.head.sha,
        state: 'failure'

      json state: 'failure', message: "#{branch.head.ref} state changed to failure"
    end
  end
end
