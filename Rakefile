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
DRAW_TESTS    = FileList['test/draw/test_*.rb']
TESTS_EXCLUDE = DRAW_TESTS

ENV['RDOC'] = 'yardoc --no-private'

default_tasks
use_bundler
test_ruby_extension
generate_documents
build_ruby_gem

task :clean => 'test:clean'

namespace :test do
  task :clean do
    sh %( rm -rf test/draw/.png/*.png )
  end

  ::Rake::TestTask.new :draw do |t|
    t.test_files = DRAW_TESTS
  end
end
