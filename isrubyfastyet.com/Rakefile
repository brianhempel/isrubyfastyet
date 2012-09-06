#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

namespace :jasminerice do
  task :run do
    Jasminerice::Runner.capybara_driver = :webkit
  end
end

require File.expand_path('../config/application', __FILE__)

IsRubyFastYet::Application.load_tasks

task :default => ['spec', 'jasminerice:run']
