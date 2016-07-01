require "httparty"
require "pry"

def filter(id)
  auth = { :username => "echoi", :password => "iloveteddie93" }
  res  = HTTParty.get "https://crownandcaliber.atlassian.net/rest/api/2/filter/#{id}", :basic_auth => auth
  body = HTTParty.get "#{res["searchUrl"]}&maxResults=500", :basic_auth => auth
end



SCHEDULER.every '1m', :first_in => 0 do |job|
  form_submissions = filter("10620")
  send_event( "inbox", current: form_submissions["issues"].count )
  body = filter("12502")

  %w(mthompson bcase yliu sbayona echoi).each do |username|
    # binding.pry
    res = body["issues"].select { |x| x["fields"]["assignee"]["name"] == username }
    send_event( username, current: res.count )
  end
end
