require "bundler/gem_tasks"


require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

#task :default => :test

require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
