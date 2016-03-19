require 'httparty'
require 'dotenv'
Dotenv.load
require 'pry'
# require 'legato'
# require 'oauth2'
require 'google/api_client'
# require "google/apis/analytics_v3"
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




SCHEDULER.every '5s', :first_in => 0 do |job|
  client = Google::APIClient.new(:application_name => 'Dashing Crown',
  :application_version => '0.01')
  analytics = client.discovered_api('analytics','v3')

  client_secrets = Google::APIClient::ClientSecrets.load #client_secrets.json must be present in current directory!
  auth_client = client_secrets.to_authorization
  auth_client.update!(
    :scope => 'https://www.googleapis.com/auth/analytics.readonly',
    :access_type => "offline", #will make refresh_token available
    :approval_prompt =>'force',
    :redirect_uri => 'http://localhost:3030/'
  )
  auth_client.refresh_token = ENV['REFRESH_TOKEN']
  auth_client.fetch_access_token!
  response = client.execute(:api_method => analytics.data.realtime.get, :authorization => auth_client, :parameters => {
    'ids' => "ga:" + "57144737",
    'dimensions' => 'ga:medium',
    'metrics' => "ga:activeVisitors"
  })
  jsonify_response = JSON.parse response.body
  count = jsonify_response["totalsForAllResults"]["ga:activeVisitors"]
  send_event('activeUsers', current: count)
end
