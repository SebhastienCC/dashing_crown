require 'httparty'
require 'dotenv'
Dotenv.load
require 'pry'
require 'legato'
require 'oauth2'
require_relative "../lib/google_token_factory"


  def auth_token
    client.update!(
      :additional_parameters => {"access_type" => "offline"}
    )
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




SCHEDULER.every '30m', :first_in => 0 do |job|
  binding.pry
  # auth_token
  # send_event('convergence', current: projects)
end
