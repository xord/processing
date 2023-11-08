require 'digest/md5'
require 'fileutils'

require_relative '../helper'
require_relative 'p5'


def md5(s)
  Digest::MD5.hexdigest s
end

def mkdir(dir: nil, filename: nil)
  path = dir || File.dirname(filename)
  FileUtils.mkdir_p path unless File.exist? path
end

def assert_draw(width = 100, height = 100, draw_src, threshold: 1.0)
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
