# -*- mode: ruby -*-


require_relative 'lib/processing/extension'


Gem::Specification.new do |s|
  glob = -> *patterns do
    patterns.map {|pat| Dir.glob(pat).to_a}.flatten
  end

  ext   = Processing::Extension
  name  = ext.name.downcase
  rdocs = glob.call *%w[README]

  s.name        = name
  s.version     = ext.version
  s.license     = 'MIT'
  s.summary     = 'Processing compatible Creative Coding Framework.'
  s.description = 'Creative Coding Framework has API compatible to Processing or p5.js.'
  s.authors     = %w[xordog]
  s.email       = 'xordog@gmail.com'
  s.homepage    = "https://github.com/xord/processing"

  s.platform              = Gem::Platform::RUBY
  s.required_ruby_version = '>= 3.0.0'

  s.add_dependency 'rexml'
  s.add_dependency 'xot',       '~> 0.3.9', '>= 0.3.9'
  s.add_dependency 'rucy',      '~> 0.3.9', '>= 0.3.9'
  s.add_dependency 'rays',      '~> 0.3.9', '>= 0.3.9'
  s.add_dependency 'reflexion', '~> 0.3.10', '>= 0.3.10'

  s.files            = `git ls-files`.split $/
  s.test_files       = s.files.grep %r{^(test|spec|features)/}
  s.extra_rdoc_files = rdocs.to_a
end
