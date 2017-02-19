class GithubClient
  def initialize
    @client = Octokit::Client.new(access_token: GITHUB_ACCESS_TOKEN)
  end

  def process_pull_request(pull_request)
    @pivotal = PivotalClient.new(pull_request)

    set_status(pull_request, state: 'pending')
    set_status(pull_request, state: 'error') unless @pivotal
    status_per_pivotal(pull_request)
  end

  def set_status(pull_request, state: '', options: {})
    @client.create_status \
      pull_request['base']['repo']['full_name'],
      pull_request['head']['sha'],
      state,
      options
  end

  def status_per_pivotal(pull_request)
    set_status \
      pull_request,
      state: @pivotal.accepted? ? 'success' : 'failure',
      options: pivotal_story_information
  end

  private

  def pivotal_story_information
    {
      target_url: @pivotal.story.url,
      # description: "Pivotal Story",
      context: 'Pivotal Acceptance State'
    }
  end
end
