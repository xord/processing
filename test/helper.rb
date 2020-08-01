# -*- coding: utf-8 -*-


%w[../xot ../rucy ../rays ../reflex .]
  .map  {|s| File.expand_path "../../#{s}/lib", __FILE__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'test/unit'
require 'xot/test'
require 'rubysketch'

include Xot::Test


unless $RAYS_NOAUTOINIT
  #def Rays.fin! () end
end


def assert_equal_vector (v1, v2, delta = 0.000001)
  assert_in_delta v1.x, v2.x, delta
  assert_in_delta v1.y, v2.y, delta
  assert_in_delta v1.z, v2.z, delta
end
