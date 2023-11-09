require 'digest/md5'
require 'fileutils'

require_relative '../helper'
require_relative 'p5'


DRAW_HEADER = <<~END
  background 100
  fill 255, 0, 0
  noStroke
END

def md5(s)
  Digest::MD5.hexdigest s
end

def mkdir(dir: nil, filename: nil)
  path = dir || File.dirname(filename)
  FileUtils.mkdir_p path unless File.exist? path
end

def assert_draw(
  *draw_sources, draw_header: nil,
  width: 100, height: 100, threshold: 0.98)

  source  = ([draw_header || DRAW_HEADER] + draw_sources).join("\n")
  path    = File.join __dir__, "p5rb", "#{md5(source)}.png"
  mkdir filename: path
  density = draw_p5rb width, height, source, path, headless: false
  gfx     = graphics(width, height, density).tap do |g|
    g.beginDraw {g.instance_eval source}
  end
  gfx.save path.sub(/\.png$/, '.actual.png')
  assert_equal_pixels gfx.loadImage(path), gfx, threshold: threshold
end
