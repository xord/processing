# -*- mode: ruby -*-


%w[../xot ../rucy ../rays ../reflex .]
  .map  {|s| File.expand_path "#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'rucy/rake'

require 'xot/extension'
require 'rucy/extension'
require 'rays/extension'
require 'reflex/extension'
require 'processing/extension'


EXTENSIONS    = [Xot, Rucy, Rays, Reflex, Processing]
TESTS_EXCLUDE = ['test/test_draw.rb']

ENV['RDOC'] = 'yardoc --no-private'

default_tasks
use_bundler
test_ruby_extension
generate_documents
build_ruby_gem

task :clean => 'test:clean'

namespace :test do
  task :clean do
    sh %( rm -rf test/p5rb )
  end

  task :draw do
    sh %( ruby test/test_draw.rb )
  end
end
