# Temporary hack for the pivotal gem since it's bugged
# require 'tracker_api/endpoints/story'

class PivotalClient
  attr_accessor :project, :story
  def initialize(pull_request)
    client = TrackerApi::Client.new(token: PIVOTAL_TRACKER_TOKEN)
    @project = client.project(PIVOTAL_PROJECT_ID)
    @pull_request = pull_request
    @story = @project.story(story_id)
  end

  def accepted?
    @story.current_state == 'accepted'
  end

  private

  def story_id
    branch_name = @pull_request.dig('head', 'ref')
    branch_name.split('_').last
  end
end
