source 'https://rubygems.org'

# Specify your gem's dependencies in fog-aws.gemspec
gemspec

gem "fog-core", :github => "fog/fog-core"
gem "fog-json", :github => "fog/fog-json"

group :test, :default do
  gem 'pry-nav'
  gem 'mime-types', '~> 3.1'
end

group :test do
  gem "simplecov"
  gem "codeclimate-test-reporter", "~> 1.0.0"
end
