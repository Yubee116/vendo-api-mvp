require 'spec_helper'

describe 'Vendo API SDK Tests - Auth' do
  describe '.get_token' do
    context 'given valid username and password' do
      xit 'returns success with access token' do
        VCR.use_cassette('auth_api/get-token-success') do
          username = '' # replace with a valid username
          password = '' # a replace with valid password
          result = VendoStoreFront::AuthApi.new.get_token(username, password)

          expect(result).to be_a(Net::HTTPSuccess)
          expect(JSON.parse(result.body)['access_token']).not_to be(nil)
          expect(JSON.parse(result.body)['refresh_token']).not_to be(nil)
        end
      end
    end

    context 'given invalid username and/or password' do
      it 'raises API Error' do
        VCR.use_cassette('auth_api/get-token-failure') do
          username = 'wrong@wrong.com'
          password = 'xxxxxxxx'

          expect { VendoStoreFront::AuthApi.new.get_token(username, password) }.to raise_error(VendoStoreFront::ApiError)
        end
      end
    end
  end

  describe '.refresh_token' do
    context 'given valid refresh_token' do
      xit 'returns success with refreshed/new access token' do
        VCR.use_cassette('auth_api/refresh-token-success') do
          refresh_token = '' # replace with a valid refresh token

          result = VendoStoreFront::AuthApi.new.refresh_token(refresh_token)

          expect(result).to be_a(Net::HTTPSuccess)
          expect(JSON.parse(result.body)['access_token']).not_to be(nil)
          expect(JSON.parse(result.body)['refresh_token']).not_to be(nil)
        end
      end
    end

    context 'given invalid refresh_token' do
      it 'raises API Error' do
        VCR.use_cassette('auth_api/refresh-token-failure') do
          invalid_refresh_token = 'xxxxx'

          expect { VendoStoreFront::AuthApi.new.refresh_token(invalid_refresh_token) }.to raise_error(VendoStoreFront::ApiError)
        end
      end
    end
  end
end
