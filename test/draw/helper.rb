require 'digest/md5'
require 'fileutils'

require_relative '../helper'
require_relative 'p5'


DRAW_HEADER = <<~END
  background 100
  fill 255, 0, 0
  noStroke
  strokeWeight 50
END

def md5(s)
  Digest::MD5.hexdigest s
end

def mkdir(dir: nil, filename: nil)
  path = dir || File.dirname(filename)
  FileUtils.mkdir_p path unless File.exist? path
end

def assert_label(index = 1)
  caller_locations[index].then {|loc| "#{loc.label}_#{loc.lineno}"}
end

def assert_draw(
  *draw_sources, draw_header: nil,
  width: 1000, height: 1000, threshold: 0.99, label: assert_label)

  source  = ([draw_header || DRAW_HEADER] + draw_sources).join("\n")
  path    = File.join __dir__, "p5rb", "#{label}_#{md5(source)}.png"
  mkdir filename: path
  density = draw_p5rb width, height, source, path, headless: true
  gfx     = graphics(width, height, density).tap do |g|
    g.beginDraw {g.instance_eval source}
  end
  gfx.save path.sub(/\.png$/, '.actual.png')
  assert_equal_pixels gfx.loadImage(path), gfx, threshold: threshold
end

def assert_fill(src, *args, **kwargs)
  assert_draw 'noStroke', src, *args, label: assert_label, **kwargs
end

def assert_stroke(src, *args, **kwargs)
  assert_draw 'noFill; stroke 0, 255, 0', src, *args, label: assert_label, **kwargs
end

def assert_fill_stroke(src, *args, **kwargs)
  assert_draw 'stroke 0, 255, 0', src, *args, label: assert_label, **kwargs
end
