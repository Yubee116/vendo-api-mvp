require 'net/http'
# require 'json'

module VendoStoreFront
  class AuthApi
    def get_token(username, password)
      raise ArgumentError, 'Missing requred parameter when calling AuthApi.get_token. Please provide both username and password parameters' if username.nil? || password.nil?

      ApiClient.new.call_api('token', 'POST', { grant_type: 'password', username: username, password: password })
      # token = JSON.parse(response.body)["access_token"]
      # refresh_token = JSON.parse(response.body)["refresh_token"]
    end

    def refresh_token(refresh_token)
      raise ArgumentError, 'Missing requred parameter when calling AuthApi.refresh_token. Please provide refresh_token' if refresh_token.nil?
      
      ApiClient.new.call_api('token', 'POST', { grant_type: 'refresh_token', refresh_token: refresh_token })
    end
  end
end
