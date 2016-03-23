require "./lib/crown_authenticate"
require "pry"
# require "httparty"
# include HTTParty


def authenticate
  token = CrownAuthenticate.new().token
end

SCHEDULER.every '5m', :first_in => 0 do |job|
  queues = HTTParty.get "https://#{ENV['CROWN_DOMAIN']}/v1/reports/delayed_jobs?authentication_token=#{authenticate}"
  array = []
  queues.keys.each do |key|
    obj = {}
    obj[:name] = key
    obj[:numbers] = queues[key]
    array << obj
  end
  send_event('delayed', queues: array)
end

#
# projects = ENV["ROLLBAR_TOKENS"].split(",").map do |token|
#   project = Rollbar::Project.new(token)
#   { name: project.name, items: project.top_active_items.first(5) }
# end
# send_event('rollbar', projects: projects)
