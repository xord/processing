# -*- mode: ruby -*-


Pod::Spec.new do |s|
  s.name         = "RubyProcessing"
  s.version      = File.readlines(File.expand_path 'VERSION', __dir__)[0].chomp
  s.summary      = "Yet Another Processing implementation for Ruby"
  s.description  = "Yet Another Processing implementation for Ruby"
  s.license      = "MIT"
  s.source       = {:git => "https://github.com/xord/processing.git"}
  s.author       = {"xordog" => "xordog@gmail.com"}
  s.homepage     = "https://github.com/xord/processing"

  s.osx.deployment_target = "10.10"
  s.ios.deployment_target = "10.0"

  incdirs = %W[
    #{s.name}/src
    CRuby/CRuby/include
    Reflexion/reflex/include
  ].map {|s| "${PODS_ROOT}/#{s}"}

  s.preserve_paths = "src"
  s.source_files   = "src/*.mm"
  s.xcconfig       = {"HEADER_SEARCH_PATHS" => incdirs.join(' ')}

  s.resource_bundles = {'RubyProcessing' => %w[lib VERSION]}
end
