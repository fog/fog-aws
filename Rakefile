require 'bundler/gem_tasks'
require 'github_changelog_generator/task'

task default: :test

mock = ENV['FOG_MOCK'] || 'true'
task :test do
  sh("export FOG_MOCK=#{mock} && bundle exec shindont")
end

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  config.user = 'fog'
  config.project = 'fog-aws'
  config.max_issues = 100

  config.future_release = 'v3.29.0'
  config.since_tag = 'v3.26.0'
end
