# -*- mode: ruby -*-


%w[../xot ../rucy ../beeps ../rays ../reflex .]
  .map  {|s| File.expand_path "#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'rucy/rake'

require 'xot/extension'
require 'rucy/extension'
require 'beeps/extension'
require 'rays/extension'
require 'reflex/extension'
require 'processing/extension'


EXTENSIONS = [Xot, Rucy, Beeps, Rays, Reflex, Processing]

ENV['RDOC'] = 'yardoc --no-private'

test_ruby_extension
generate_documents
build_ruby_gem

task :default


namespace :version do

  namespace :bump do

    task :major do
      update_and_tag_version 0
    end

    task :minor do
      update_and_tag_version 1
    end

    task :patch do
      update_and_tag_version 2
    end

    task :build do
      update_and_tag_version 3
    end

  end# bump

end# version
