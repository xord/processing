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


EXTENSIONS = [Xot, Rucy, Rays, Reflex, Processing]

ENV['RDOC'] = 'yardoc --no-private'

default_tasks
test_ruby_extension
generate_documents
build_ruby_gem

task :test => 'test:clean'

namespace :test do
  task :clean do
    sh %( rm -rf test/p5rb )
  end
end
