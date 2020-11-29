%w[xot rays reflex rubysketch]
  .map  {|s| File.expand_path "../../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'rubysketch-processing'


w, h = width, height

cam = Capture.new w, h, Capture.list.last
cam.start

images = 60.times.map {
  Graphics.new w, h
}

draw do
  if frameCount % 2 == 0
    images.unshift images.pop
    images.first.tap do |image|
      image.beginDraw {
        image.image cam, 0, 0
      }
    end
  end

  background 0
  segment_h= h / images.size
  images.each.with_index do |image, i|
    y = i * segment_h
    copy image, 0, y, w, segment_h, 0, y, w, segment_h
  end
end
