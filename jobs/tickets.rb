require "httparty"
require "pry"

def filter(id)
  auth = { :username => "mthompson", :password => "m200266756" }
  res  = HTTParty.get "https://crownandcaliber.atlassian.net/rest/api/2/filter/#{id}", :basic_auth => auth
  body = HTTParty.get res["searchUrl"], :basic_auth => auth
end



11102
SCHEDULER.every '1m', :first_in => 0 do |job|
  form_submissions = filter("11102")
  send_event( "inbox", current: form_submissions.count )

  %w(mthompson bcase yliu).each do |username|
    body = filter("10802")
    res = body["issues"].select { |x| x["fields"]["assignee"]["name"] == username }
    send_event( username, current: res.count )
  end
end
