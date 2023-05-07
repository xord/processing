%w[../xot ../rucy ../rays ../reflex .]
  .map  {|s| File.expand_path "../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'xot/test'
require 'processing/all'

require 'test/unit'

include Xot::Test


def assert_equal_vector(v1, v2, delta = 0.000001)
  assert_in_delta v1.x, v2.x, delta
  assert_in_delta v1.y, v2.y, delta
  assert_in_delta v1.z, v2.z, delta
end

def graphics(width = 10, height = 10, &block)
  Processing::Graphics.new(width, height).tap do |g|
    g.beginDraw {block.call g, g.getInternal__} if block
  end
end
