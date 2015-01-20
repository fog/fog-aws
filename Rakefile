require "bundler/gem_tasks"
require "rspec/core/rake_task"

task :default => :test

mock = ENV['FOG_MOCK'] || "true"

task :test => ["test:shindo", "test:rspec"]

namespace :test do
  desc 'Run shindo tests'
  task :shindo do
    sh("export FOG_MOCK=#{mock} && bundle exec shindont")
  end
  RSpec::Core::RakeTask.new(:rspec)
end
