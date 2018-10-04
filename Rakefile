require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end
Rake::TestTask.new(:test_one) do |t|
  t.libs << "test"
  t.libs << "lib"
  # Since ARGV[0] is the test_one, the task name
  filename = ARGV[1]
  t.test_files = FileList["test/**/#{filename}_test.rb"]

end

task :default => :test
