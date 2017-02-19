class GithubClient
  def initialize
    @client = Octokit::Client.new(access_token: GITHUB_ACCESS_TOKEN)
  end

  def set_state(pull_request, state: '', options: {})
    @client.create_status \
      pull_request['base']['repo']['full_name'],
      pull_request['head']['sha'],
      state,
      options
  end

  def set_pivotal_state(pull_request, pivotal_project: {})
    state = approved?(pivotal_project.accepted?)
    options = pivotal_story_information(pivotal_project)
    set_state(pull_request, state: state, options: options)
  end

  private

  def approved?(pivotal_state)
    pivotal_state ? 'success' : 'failure'
  end

  def pivotal_story_information(pivotal_project)
    {
      target_url: pivotal_project.story.url,
      # description: "Pivotal Story",
      context: 'Pivotal Acceptance State'
    }
  end
end
