#Temporary hack for the pivotal gem since it's bugged
require 'tracker_api/endpoints/story'

class PivotalClient
  attr_accessor :project
  def initialize(project_id:)
    client = TrackerApi::Client.new(token: ENV['PIVOTAL_TRACKER_TOKEN'])
    @project = client.project(project_id)
  end

  def accepted?(story_id:)
    @project.story(story_id).current_state == 'accepted'
  end
end
