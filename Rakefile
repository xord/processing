# -*- mode: ruby -*-


%w[../xot ../rucy ../rays ../reflex .]
  .map  {|s| File.expand_path "#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'rucy/rake'

require 'xot/module'
require 'rucy/module'
require 'rays/module'
require 'reflex/module'
require 'processing/module'


MODULES = [Xot, Rucy, Rays, Reflex, Processing]

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
