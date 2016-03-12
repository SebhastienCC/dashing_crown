require "httparty"
require "pry"

def filter
  auth = { :username => "mthompson", :password => "m200266756" }
  res  = HTTParty.get "https://crownandcaliber.atlassian.net/rest/api/2/filter/10802", :basic_auth => auth
  body = HTTParty.get res["searchUrl"], :basic_auth => auth
end



SCHEDULER.every '1m', :first_in => 0 do |job|
  %w(mthompson bcase yliu).each do |username|
    body = filter
    res = body["issues"].select { |x| x["fields"]["assignee"]["name"] == username }
    send_event( username, current: res.count )
  end
end
