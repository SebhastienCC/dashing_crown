# require 'httparty'
# require 'dotenv'
# Dotenv.load
# require 'pry'
#
# module Rollbar
#   class Project
#     include HTTParty
#     base_uri 'https://api.rollbar.com/api/1'
#
#     def initialize(key)
#       self.class.default_params access_token: key
#     end
#
#     def name
#       self.class.get("/project")["result"]["name"]
#     end
#
#     def top_active_items
#       self.class.get("/reports/top_active_items")["result"]
#     end
#   end
# end
#
# SCHEDULER.every '1m', :first_in => 0 do |job|
#   projects = ENV["ROLLBAR_TOKENS"].split(",").map do |token|
#     project = Rollbar::Project.new(token)
#     { name: project.name, items: project.top_active_items.first(5) }
#   end
#   send_event('rollbar', projects: projects)
# end
