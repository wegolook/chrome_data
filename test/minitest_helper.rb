$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'chrome_data'

require 'minitest/spec'
require 'minitest/autorun'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { match_requests_on: [:method, :uri, :body] }
end