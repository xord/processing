%w[../xot ../rucy ../rays ../reflex .]
  .map  {|s| File.expand_path "../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'xot/test'
require 'processing/all'

require 'tempfile'
require 'digest/md5'
require 'fileutils'
require 'test/unit'

require_relative 'p5'

include Xot::Test


def md5(s)
  Digest::MD5.hexdigest s
end

def mkdir(dir: nil, filename: nil)
  path = dir || File.dirname(filename)
  FileUtils.mkdir_p path unless File.exist? path
end

def temppath(ext: nil, &block)
  f     = Tempfile.new
  path  = f.path
  path += ".#{ext}" if ext
  f.close!
  block.call path
  File.delete path
end

def get_pixels(image)
  %i[@image @image__]
    .map {image.instance_variable_get _1}
    .compact
    .first
    .bitmap
    .to_a
end

def graphics(width = 10, height = 10, *args, &block)
  Processing::Graphics.new(width, height, *args).tap do |g|
    g.beginDraw {block.call g, g.getInternal__} if block
  end
end

def assert_equal_vector(v1, v2, delta = 0.000001)
  assert_in_delta v1.x, v2.x, delta
  assert_in_delta v1.y, v2.y, delta
  assert_in_delta v1.z, v2.z, delta
end

def assert_equal_pixels(expected, actual, threshold: 1.0)
  exp_pixels = get_pixels expected
  act_pixels = get_pixels actual
  raise "Number of pixels does not match" if act_pixels.size != exp_pixels.size

  equal_count = exp_pixels.zip(act_pixels).count {|a, b| a == b}
  equal_rate  = equal_count.to_f / act_pixels.size.to_f
  assert equal_rate >= threshold, <<~EOS
    The rate of the same pixel #{equal_rate} is below the threshold #{threshold}
  EOS
end

def assert_draw(width, height, draw_src, threshold: 1.0)
  path    = File.join __dir__, "p5rb", "#{md5(draw_src)}.png"
  mkdir filename: path
  density = draw_p5rb width, height, draw_src, path, headless: false
  gfx     = graphics(width, height, density).tap do |g|
    g.beginDraw do
      g.background 0
      g.fill 255, 0, 0
      g.noStroke
      g.instance_eval draw_src
    end
  end
  gfx.save path.sub(/\.png$/, '.actual.png')
  assert_equal_pixels gfx.loadImage(path), gfx, threshold: threshold
end
