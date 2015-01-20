ENV['FOG_MOCK'] ||= 'true'

begin
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
rescue LoadError => e
  $stderr.puts "not recording test coverage: #{e.inspect}"
end

Bundler.require(:test)

require File.expand_path("../../lib/fog/aws", __FILE__)
require File.expand_path("../../tests/helpers/mock_helper", __FILE__)
Excon.defaults.merge!(debug_request: true, debug_response: true)
Dir[File.expand_path("../{shared,support}/*.rb", __FILE__)].each { |f| require(f) }

# This overrides the default 600 seconds timeout during live test runs
if Fog.mocking?
  Fog.timeout = ENV['FOG_TEST_TIMEOUT'] || 2000
  Fog::Logger.warning "Setting default fog timeout to #{Fog.timeout} seconds"
end

RSpec.configure do |config|
  config.filter_run_excluding(:not_mocked) if Fog.mocking?
end
