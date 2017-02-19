class PivotalStatusesController < ApplicationController
  post '/event_handler' do
    payload = JSON.parse(params[:payload])
    puts 'Well, it worked!'
    render :success, payload
  end
end
