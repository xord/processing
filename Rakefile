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


def test_with_browser()
  ENV['TEST_WITH_BROWSER'] = '1'
end

EXTENSIONS = [Xot, Rucy, Rays, Reflex, Processing]

ENV['RDOC'] = 'yardoc --no-private'

#test_with_browser if ci?

default_tasks
use_bundler
test_ruby_extension
generate_documents
build_ruby_gem

task :clean => 'test:clean'

namespace :test do
  task :clean do
    sh %( rm -rf test/.png/*.png )
  end

  task :with_browser do
    test_with_browser
  end

  ::Rake::TestTask.new :draw do |t|
    t.test_files = FileList['test/test_*.rb']
  end
end
