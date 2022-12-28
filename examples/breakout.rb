%w[xot rays reflex processing]
  .map  {|s| File.expand_path "../../#{s}/lib", __dir__}
  .each {|s| $:.unshift s if !$:.include?(s) && File.directory?(s)}

require 'processing/include'


PADDING = 50
BRICK_COUNT = 10

$objs = []
$bar = nil
$gameover = false

setup do
  addWalls
  addBricks

  colorMode HSB, 360, 100, 100
  ellipseMode CORNER
  background 0
  noStroke
  fill 0, 0, 100
end

draw do
  background 0
  $objs.each do |o|
    o.update
    o.draw
  end
  drawTexts
end

mousePressed do
  start unless started?
end

mouseDragged do
  $bar.pos.x = mouseX - $bar.w / 2 if $bar
end

def start()
  $bar = Bar.new
  $objs += [$bar, Ball.new($bar)]
end

def started?()
  $bar
end

def gameover?()
  started? &&
    $objs.count {|o| o.kind_of? Ball} == 0
end

def cleared?()
  started? && !gameover? &&
    $objs.count {|o| o.kind_of? Brick} == 0
end

def addWalls()
  left = Obj.new 0, 0, 10, height
  top = Obj.new 0, 0, width, 10
  right = Obj.new width - 10, 0, 10, height
  bottom = Bottom.new 0, height - 10, width, 10
  $objs += [top, bottom, left, right]
end

def addBricks()
  brickW = (width - PADDING * 2) / BRICK_COUNT
  5.times do |y|
    BRICK_COUNT.times do |x|
      xx = PADDING + brickW * x
      yy = PADDING + 30 * y
      $objs.push Brick.new(xx, yy, brickW - 5, 20, y * 60)
    end
  end
end

def drawTexts()
  push do
    textAlign CENTER, CENTER

    if !started?
      fill 50, 100, 100
      textSize 50
      text "BREAKOUT", 0, 0, width, height
      textSize 20
      translate 0, 100
      text "Tap to start!", 0, 0, width, height
    elsif cleared?
      fill 100, 80, 100
      textSize 50
      text "CLEAR!", 0, 0, width, height
    elsif gameover?
      fill 0, 20, 100
      textSize 50
      text "GAMEOVER", 0, 0, width, height
    end
  end
end

class Obj
  attr_reader :pos, :w, :h, :vel

  def initialize(x, y, w, h, vx = 0, vy = 0)
    @pos = createVector x, y
    @w, @h = w, h
    @vel = createVector vx, vy
  end

  def update()
    @pos.add @vel
  end

  def draw()
    rect @pos.x, @pos.y, @w, @h
  end

  def bounds()
    x, y = @pos.x, @pos.y
    return x, y, x + @w, y + @h
  end

  def center()
    createVector @pos.x + @w / 2, @pos.y + @h / 2
  end
end

class Ball < Obj
  def initialize(bar)
    super bar.pos.x, bar.pos.y - bar.h, 20, 20
    self.vel = createVector random(-1, 1), -1
  end

  def vel=(v)
    @vel = v.dup.normalize.mult 8
  end

  def update()
    b = bounds.dup
    super
    checkHit b
  end

  def checkHit(prevBounds)
    x1, y1, x2, y2 = prevBounds
    hitH = hitV = false
    hits = []
    $objs.each do |o|
      next if o == self
      next unless intersect? o
      hits.push o
      ox1, oy1, ox2, oy2 = o.bounds
      hitH ||= !overlap?(x1, x2, ox1, ox2)
      hitV ||= !overlap?(y1, y2, oy1, oy2)
    end
    vel.x *= -1 if hitH
    vel.y *= -1 if hitV

    hits.each {|o| hit o}
  end

  def intersect?(o)
    x1, y1, x2, y2 = bounds
    ox1, oy1, ox2, oy2 = o.bounds
    overlap?(x1, x2, ox1, ox2) && overlap?(y1, y2, oy1, oy2)
  end

  def overlap?(a1, a2, b1, b2)
    a1 <= b2 && b1 <= a2
  end

  def hit(o)
    case o
    when Bar then self.vel = center.sub o.center
    when Brick then $objs.delete o
    when Bottom then $objs.delete self unless cleared?
    end
  end
end

class Bar < Obj
  def initialize()
    w = 100
    super (width - w) / 2, height - 50, w, 20
  end
end

class Brick < Obj
  def initialize(x, y, w, h, hue)
    super x, y, w, h
    @hue = hue
  end

  def draw()
    push do
      fill @hue, 50, 100
      super
    end
  end
end

class Bottom < Obj
  def draw()
    push do
      fill 0, 0, 50
      super
    end
  end
end
