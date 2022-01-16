# -*- mode: ruby -*-


Pod::Spec.new do |s|
  s.name         = "RubySketch"
  s.version      = File.readlines(File.expand_path 'VERSION', __dir__)[0].chomp
  s.summary      = "Yet Another Processing implementation for Ruby"
  s.description  = "Yet Another Processing implementation for Ruby"
  s.license      = "MIT"
  s.source       = {:git => "https://github.com/xord/rubysketch.git"}
  s.author       = {"xordog" => "xordog@gmail.com"}
  s.homepage     = "https://github.com/xord/rubysketch"

  incdirs = %W[
    #{s.name}/src
    CRuby/CRuby/include
  ].map {|s| "${PODS_ROOT}/#{s}"}

  s.preserve_paths = "src"
  s.source_files   = "src/*.m"
  s.xcconfig       = {"HEADER_SEARCH_PATHS" => incdirs.join(' ')}

  s.resource_bundles = {'RubySketch' => 'lib'}
end
