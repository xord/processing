# Processing for CRuby - A Processing-compatible creative coding framework

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/xord/processing)
![License](https://img.shields.io/github/license/xord/processing)
![Build Status](https://github.com/xord/processing/actions/workflows/test.yml/badge.svg)
![Gem Version](https://badge.fury.io/rb/processing.svg)

## ⚠️  Notice

This repository is a read-only mirror of our monorepo.
We do not accept pull requests or direct contributions here.

### 🔄 Where to Contribute?

All development happens in our [xord/all](https://github.com/xord/all) monorepo, which contains all our main libraries.
If you'd like to contribute, please submit your changes there.

For more details, check out our [Contribution Guidelines](./CONTRIBUTING.md).

Thanks for your support! 🙌

## 🚀 About

**Processing for CRuby** is an independent, OpenGL-based Ruby implementation of the [Processing](https://processing.org/) API. It is **not** affiliated with the original Processing project, and it is not the JRuby / JOGL-based [`ruby-processing`](https://github.com/jashkenas/ruby-processing) either — this gem runs on CRuby (MRI), and all rendering goes through the `xord/*` family's own OpenGL 2D drawing engine ([Rays](https://github.com/xord/rays), via [Reflex](https://github.com/xord/reflex)).

Write a `setup do ... end` and a `draw do ... end` at the top of a Ruby file, run it, and a window appears — just like a `.pde` sketch. This gem is the thin, pure-Ruby layer that maps Processing's vocabulary onto the underlying engine (windowing, drawing, input, MIDI, camera, physics).

> Looking for the same API on mobile / with a game-engine flavor? See [RubySketch](https://github.com/xord/rubysketch).

## 📋 Requirements

- Ruby **3.0.0** or later
- All the runtime requirements of [Reflex](https://github.com/xord/reflex) (which in turn brings Rays, Rucy, Xot, plus the platform GUI backend — AppKit / UIKit / Win32 / SDL2 — and OpenGL)
- The dependent gems are installed automatically: `rexml`, `xot`, `rucy`, `rays`, `reflexion`

There is no native C/C++ extension in this gem; the heavy lifting is done by the dependencies' extensions.

## 📦 Installation

Add this line to your Gemfile:
```ruby
gem 'processing'
```

Then install:
```bash
$ bundle install
```

Or install it directly:
```bash
$ gem install processing
```

## 📚 What's Provided

`require 'processing'` exposes a `Processing` module that, when activated, makes the Processing API available as top-level methods inside the current file. There are two ways to activate it.

### Two ways to use the gem

| Style                          | How                                                                                       |
| ------------------------------ | ----------------------------------------------------------------------------------------- |
| **Refinement, camelCase**      | `require 'processing'` + `using Processing` — the standard, Processing-compatible style   |
| **Refinement, snake_case too** | `require 'processing'` + `using Processing(snake_case: true)` — adds Ruby-idiomatic aliases (`color_mode`, `ellipse_mode`, ...) alongside the camelCase originals |

In both cases, the framework opens a window for you and runs the sketch automatically when the file exits. You do not need an explicit `start` call.

### Core API

| Area              | Examples                                                                                            |
| ----------------- | --------------------------------------------------------------------------------------------------- |
| Sketch lifecycle  | `setup`, `draw`, `windowResized`, `windowMoved`                                                     |
| State             | `size`, `frameRate`, `frameCount`, `width`, `height`, `pixelDensity`, `noLoop` / `loop_` / `redraw` |
| Color & state     | `background`, `fill`, `stroke`, `noFill`, `noStroke`, `strokeWeight`, `colorMode`, `blendMode`      |
| Shapes            | `point`, `line`, `rect`, `square`, `triangle`, `quad`, `ellipse`, `circle`, `arc`, `curve`, `bezier`, `beginShape` / `endShape` / `vertex` |
| Transforms        | `push` / `pop`, `pushMatrix` / `popMatrix`, `translate`, `rotate`, `scale`, `shearX`, `shearY`      |
| Text              | `text`, `textSize`, `textFont`, `textAlign`, `textWidth`, `loadFont`                                |
| Images            | `image`, `loadImage` (file path *or* URL), `createImage`, `tint`, `noTint`                          |
| Vectors & math    | `PVector`, `createVector`, `random`, `noise`, `map`, `lerp`, `dist`, `radians`, `degrees`           |
| Input             | `mousePressed`, `mouseReleased`, `mouseMoved`, `mouseDragged`, `mouseClicked`, `doubleClicked`, `mouseWheel`, `keyPressed`, `keyReleased`, `keyTyped`, `touchStarted` / `touchEnded` / `touchMoved`, `motion` |
| Live state        | `mouseX`, `mouseY`, `pmouseX`, `pmouseY`, `key`, `keyCode`, `touches`                               |
| Off-screen buffer | `createGraphics` → a `Graphics` object that shares the same drawing API                             |
| Shapes / SVG      | `createShape`, `loadShape` (SVG)                                                                    |
| Shaders           | `loadShader`, `shader`, `resetShader` — GLSL shaders go straight to the OpenGL pipeline             |
| Camera            | `createCapture` — live camera capture via `Rays::Camera`                                            |

### Top-level constants

The familiar Processing constants are defined: `RGB`, `HSB`, `RADIANS`, `DEGREES`, `CORNER`, `CORNERS`, `CENTER`, `RADIUS`, `LEFT`, `RIGHT`, `TOP`, `BOTTOM`, `BASELINE`, `BLEND`, `ADD`, `MULTIPLY`, `SCREEN`, ...

### Internal API convention

Methods ending in `__` (e.g. `init__`, `beginDraw__`, `@context__`) are framework internals and are deliberately excluded from the refinement-exposed top-level method set, so they will not collide with names in your sketch.

## 💡 Usage

### Hello, world

```ruby
require 'processing'
using Processing

draw do
  background 0, 10           # alpha trail
  textSize 50
  text 'hello, world!', mouseX, mouseY
end
```

Save as `hello.rb`, then `ruby hello.rb`. A 500 × 500 window opens automatically.

### `setup` and `draw`

```ruby
require 'processing'
using Processing

setup do
  size 600, 400
  colorMode RGB, 1
  angleMode DEGREES
end

draw do
  background 0
  fill 1, 0.4, 0.1
  stroke 1
  strokeWeight 2

  rectMode CENTER
  push
    translate width / 2, height / 2
    rotate frameCount      # one degree per frame
    rect 0, 0, 200, 120, 12
  pop
end
```

### Loading an image from a URL

```ruby
require 'processing'
using Processing

icon = loadImage 'https://xord.org/rubysketch/images/rubysketch128.png'

draw do
  background 0, 10
  image icon, mouseX, mouseY, icon.width / 10, icon.height / 10
end
```

### Mouse and keyboard input

```ruby
require 'processing'
using Processing

setup { background 0 }

draw do
  fill 1
  ellipse mouseX, mouseY, 20, 20
end

mousePressed { background 0 }
keyPressed   { puts "pressed: #{key.inspect} (#{keyCode})" }
```

### Snake_case aliases

```ruby
require 'processing'
using Processing(snake_case: true)

draw do
  background 0
  fill 1
  stroke_weight 4              # alias of strokeWeight
  no_fill                      # alias of noFill
  ellipse mouse_x, mouse_y, 50, 50
end
```

### Off-screen rendering with `createGraphics`

```ruby
require 'processing'
using Processing

g = nil

setup do
  size 400, 400
  g = createGraphics 200, 200
  g.beginDraw
  g.background 0, 100, 200
  g.fill 255
  g.ellipse 100, 100, 120, 120
  g.endDraw
end

draw do
  background 0
  image g, mouseX - 100, mouseY - 100
end
```

More examples live in [`examples/`](./examples) — `breakout.rb`, `camera.rb`, `clock.rb`, `delay_camera.rb`, `filter.rb`, `image.rb`, `shake.rb`, `shapes.rb`.

## 🛠️ Development

```bash
$ rake test         # run the test suite (drawing tests run headless by default)
$ rake test:draw    # run drawing tests only
$ rake doc          # generate YARD docs
$ rake              # default tasks
```

Visual regression tests can be enabled with `TEST_WITH_BROWSER=1` — the suite then drives [Ferrum](https://github.com/rubycdp/ferrum) to capture browser-rendered screenshots and compare them against the gem's output.

In the [`xord/all`](https://github.com/xord/all) monorepo you can scope by module, e.g. `rake processing test`.

## 📜 License

**Processing for CRuby** is licensed under the MIT License.
See the [LICENSE](./LICENSE) file for details.

This project is not affiliated with [Processing.org](https://processing.org/); it is an independent reimplementation of their API.
