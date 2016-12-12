require 'bundler'
require 'bundler/gem_tasks'
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.verbose = false
end


# temporary fix for NoMethodError: undefined method `last_comment' for rake
module FixForRakeLastCommentError
  def last_comment
    last_description
  end
end
Rake::Application.send :include, FixForRakeLastCommentError

task :default => :test