ENV['SINATRA_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

# ActiveRecord::Base.establish_connection(
#   :adapter => "sqlite3",
#   :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
# )
GITHUB_ACCESS_TOKEN = ENV['GITHUB_ACCESS_TOKEN']
PIVOTAL_TRACKER_TOKEN = ENV['PIVOTAL_TRACKER_TOKEN']
PIVOTAL_PROJECT_ID = ENV['PIVOTAL_PROJECT_ID']
require_all 'app'
