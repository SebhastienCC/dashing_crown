class CrownAuthenticate
  require "httparty"
  include HTTParty
  require 'dotenv'
  Dotenv.load


  base_uri "https://#{ENV['CROWN_DOMAIN']}/v1/"
  attr_accessor :token

  def initialize
    @token = self.class.post('/authenticate', body: auth_criteria)["authentication_token"]
  end

  def auth_criteria
    {
      email: ENV["CROWN_SERVICE_EMAIL"],
      password: ENV["CROWN_SERVICE_PW"]
    }
  end
end
