require "bundler/gem_tasks"

task :default => [:test]

task :test do
  Dir.glob('test/**/*_test.rb').each do |file|
    require File.expand_path(file)
  end
end
