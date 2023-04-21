# -*- mode: ruby -*-


File.expand_path('lib', __dir__)
  .tap {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'processing/extension'


Gem::Specification.new do |s|
  glob = -> *patterns do
    patterns.map {|pat| Dir.glob(pat).to_a}.flatten
  end

  ext   = Processing::Extension
  name  = ext.name.downcase
  rdocs = glob.call *%w[README]

  s.name        = name
  s.summary     = 'Processing compatible Creative Coding Framework.'
  s.description = 'Creative Coding Framework has API compatible to Processing or p5.js.'
  s.version     = ext.version

  s.authors  = %w[xordog]
  s.email    = 'xordog@gmail.com'
  s.homepage = "https://github.com/xord/processing"

  s.platform              = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.7.0'

  s.add_runtime_dependency 'xot',       '~> 0.1.33'
  s.add_runtime_dependency 'rucy',      '~> 0.1.33'
  s.add_runtime_dependency 'rays',      '~> 0.1.33'
  s.add_runtime_dependency 'reflexion', '~> 0.1.33'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'test-unit'
  s.add_development_dependency 'yard'

  s.files            = `git ls-files`.split $/
  s.test_files       = s.files.grep %r{^(test|spec|features)/}
  s.extra_rdoc_files = rdocs.to_a
end
