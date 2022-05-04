require 'simplecov'
SimpleCov.start
require 'vcr'
require 'vendo_storefront'
require 'json'

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = false
end