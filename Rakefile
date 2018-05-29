require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppet_blacksmith/rake_tasks' if Bundler.rubygems.find_name('puppet-blacksmith').any?

PuppetLint.configuration.send('disable_relative')

require 'github_changelog_generator/task'
GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  version = (Blacksmith::Modulefile.new).version
  config.future_release = "v#{version}"
  config.header = "# Change log\n\nAll notable changes to this project will be documented in this file.\nEach new release typically also includes the latest modulesync defaults.\nThese should not impact the functionality of the module."
  config.exclude_labels = %w{duplicate question invalid wontfix modulesync}
end
