require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rbconfig'

CLEAN.include('**/*.rbc', '**/*.rbx', '**/*.gem')

namespace 'gem' do
  desc 'Create the itunes-dedup gem'
  task :create => [:clean] do
    spec = eval(IO.read('itunes-dedup.gemspec'))
    Gem::Builder.new(spec).build
  end

  desc 'Install the itunes-dedup gem'
  task :install => [:create] do
     file = Dir["*.gem"].first
     sh "gem install #{file}"
  end
end

Rake::TestTask.new do |t|
  t.verbose = true
  t.warning = true
end

task :default => :test
