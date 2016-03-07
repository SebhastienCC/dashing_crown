# require 'httparty'
require 'dotenv'
Dotenv.load
require 'pry'
require 'legato'
require 'oauth2'
require_relative "../lib/google_token_factory"


  def auth_token
    client = OAuth2::Client.new(ENV['CLIENT_ID'], ENV['CLIENT_SECRET'], {
      :authorize_url => 'https://accounts.google.com/o/oauth2/auth',
      :token_url => 'https://accounts.google.com/o/oauth2/token'
    })
    client.auth_code.authorize_url({
      :scope => 'https://www.googleapis.com/auth/analytics.readonly',
      :redirect_uri => ENV["DOMAIN"],
      :access_type => 'offline'
    })
  end




SCHEDULER.every '30s', :first_in => 0 do |job|
  # auth_token
  # send_event('rollbar', projects: projects)
end
