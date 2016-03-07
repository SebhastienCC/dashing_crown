class GoogleTokenFactory
  def self.fetch_access_token_via(refresh_token:)
    google = Google::APIClient.new
    google.authorization.client_id = ENV.fetch('GOOGLE_CLIENT_ID')
    google.authorization.client_secret = ENV.fetch('GOOGLE_CLIENT_SECRET')
    google.authorization.scope = "https://www.googleapis.com/auth/drive https://www.googleapis.com/auth/userinfo.profile"
    google.authorization.redirect_uri = "http://localhost"

    client = google.authorization.dup
    client.refresh_token = refresh_token
    client.fetch_access_token!
    client.access_token
  end
end
