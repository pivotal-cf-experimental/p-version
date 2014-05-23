require 'cucumber'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

Rubocop::RakeTask.new

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = 'features --format pretty'
end

RSpec::Core::RakeTask.new(:spec)

task default: [:rubocop, :spec, :features]
