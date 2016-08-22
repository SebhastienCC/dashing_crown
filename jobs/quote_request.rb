require "./lib/crown_authenticate"
# require "httparty"
# include HTTParty


def authenticate
  token = CrownAuthenticate.new().token
end

SCHEDULER.every '5m', :first_in => 0 do |job|
  response = HTTParty.get "https://#{ENV['CROWN_DOMAIN']}/v1/quote_requests?authentication_token=#{authenticate}"
  send_event('quote_request', current: response["quote_requests"].length)
  send_event('quote_request', currentUnprocessed: response["unprocessed_quote_requests"].length)
end
