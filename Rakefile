# -*- mode: ruby -*-


%w[../xot ../rays ../reflex .]
  .map  {|s| File.expand_path "#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'xot/module'
require 'rays/module'
require 'reflex/module'
require 'rubysketch/module'


MODULES = [Xot, Rays, Reflex, RubySketch]

generate_documents
build_ruby_gem

task :default => :test
