# processing ChangeLog


## [v1.1.10] - 2025-05-12

- Update dependencies


## [v1.1.9] - 2025-05-11

- Update dependencies


## [v1.1.8] - 2025-04-08

- Update dependencies: xot, rucy, rays, reflex


## [v1.1.7] - 2025-03-24

- Add PULL_REQUEST_TEMPLATE.md
- Add CONTRIBUTING.md


## [v1.1.6] - 2025-03-07

- Add keyIsRepeat
- Add Vector#-@

- Painter#background: Clearing background with transparency uses blend_mode with :replace to replace alpha value
- Fix p5.rb version

- Fix smaller-than-expected height of screenshots rendered in headless chrome


## [v1.1.5] - 2025-01-30

- Do not define snake_case methods by default


## [v1.1.4] - 2025-01-27

- Event blocks can be defined as methods with 'def'
- Alias snake case methods
- ellipse() can take 3 params


## [v1.1.3] - 2025-01-23

- Update dependencies


## [v1.1.2] - 2025-01-14

- Update workflow files
- Set minumum version for runtime dependency


## [v1.1.1] - 2025-01-13

- Update URLs as p5js.org has been relaunched
- Update LICENSE

- Fix a bug in which the display magnification was fixed at 1x when the size specified by size() was different from the window size and the aspect ratio of both windows was the same


## [v1.1] - 2024-07-06

- Support Windows


## [v1.0.3] - 2024-07-05

- Update workflows for test
- Update to actions/checkout@v4


## [v1.0.2] - 2024-03-14

- Add 'rexml' to gemspec dependency


## [v1.0.1] - 2024-03-14

- Add 'rexml' to Gemfile


## [v1.0] - 2024-03-14

- Add stroke(), setStroke(), and setStrokeWeight() to Shape class
- Add setStrokeCap() and setStrokeJoin() to Shape class
- Add join type 'miter-clip' and 'arcs'
- Add color codes
- Add loadShape()

- Rename the join type 'SQUARE' to 'BEVEL'

- Fix that <circle> and <ellipse> had half diameters


## [v0.5.34] - 2024-02-16

- Add '@see' links to documents
- Fix missing nil returning


## [v0.5.33] - 2024-02-07

- Add curveDetail() and bezierDetail()
- Add curvePoint(), curveTangent(), curveTightness(), bezierPoint(), and bezierTangent()
- Add textLeading()
- Add deltaTime
- Add hue(), saturation(), and brightness()
- Add noiseSeed() and noiseDetail()
- Add randomGaussian()
- Add randomSeed()
- Add rotateX(), rotateY(), and rotateZ()
- Add rotateX(), rotateY(), and rotateZ() to Shape class
- Add shearX() and shearY()
- Add applyMatrix()
- Add printMatrix()
- Add fullscreen() (fullScreen()) function
- Add smooth() and noSmooth()
- Add keyIsDown()
- Add keyIsPressed()
- Add mouseWheel()
- Add doubleClicked()
- Add renderMode()

- Setup view projection matrix by using perspective() instead of ortho()
- Display window in the center of the screen by default
- loadImage() uses Net::HTTP.get() instead of URI.open() to retrieve images via http(s)
- loadImage() writes a file in streaming mode
- loadImage() raises Net::HTTPClientException instead of OpenURI::HTTPError
- Reimplement the noise() for better compatibility
- push/popStyle() manage colorMode, angleMode, blendMode, and miter_limit states
- size() and createCanvas() resize the window by themselves
- texture_mode/wrap -> texcoord_mode/wrap
- updatePixels() can take block

- Fix that textFont() did not return current font
- Fix that updatePixels() did not update the texture
- Fix the performance of requestImage() by calling Thread.pass
- Fix an issue with unintended canvas resizing when the screen pixel density changes
- Fix some missing attribute copies on the canvas
- Fix Matrix::to_a order


## [v0.5.32] - 2024-01-08

- Add requestImage()
- Add texture(), textureMode(), and textureWrap()
- Add loadPixels(), updatePixels(), and pixels()
- Add curveVertex(), bezierVertex(), and quadraticVertex()
- Add beginContour() and endContour()
- Add createFont(), loadFont(), and Font.list()
- Add Shape#setFill

- vertex() can teke UV parameters
- vertex() records the fill color
- Drawing shapes with texture is affected by tin() instead of the fill()


## [v0.5.31] - 2023-12-09

- Add Shape class
- Add createShape(), shape(), shapeMode()
- Add beginShape(), endShape(), and vertex(x, y)
- Test with p5.rb
- GraphicsContext#scale() can take z parameter
- Set default miter_limit to 10
- Trigger github actions on all pull_request


## [v0.5.30] - 2023-11-09

- Test drawing methods with p5.rb
- Add .github/workflows/test-draw.yml
- Use Gemfile to install gems for development instead of add_development_dependency in gemspec


## [v0.5.29] - 2023-10-29

- Update dependencies


## [v0.5.28] - 2023-10-25

- Add GraphicsContext#clear
- Add Graphics#save
- save() returns nil


## [v0.5.27] - 2023-07-30

- Update dependencies


## [v0.5.26] - 2023-07-30

- add windowOrientation()


## [v0.5.25] - 2023-07-21

- Timer block can call drawing methods
- Add Processing::Window#update_window, and delete RubySketch::Window class


## [v0.5.24] - 2023-07-11

- Resize the canvas when the window is resized


## [v0.5.23] - 2023-07-11

- Update dependencies


## [v0.5.22] - 2023-07-10

- Update dependencies


## [v0.5.21] - 2023-07-09

- calling setup() without block does nothing


## [v0.5.20] - 2023-06-27

- Update dependencies


## [v0.5.19] - 2023-06-22

- Update dependencies


## [v0.5.18] - 2023-06-11

- mousePressed, mouseReleased, mouseMoved, mouseDragged, mouseClicked ignore multiple touches
- Fix that pointer event handles only the first pointer’s type and ignoring rest pointer's types


## [v0.5.17] - 2023-06-07

- Add Image#set() and Image#get()
- Add color(), red(), green(), blue(), and alpha()
- Add lerpColor()
- Add focused()


## [v0.5.16] - 2023-06-02

- Fix failed tests and add tests


## [v0.5.15] - 2023-06-02

- Set initial canvas size to same as the window size
- Use WIDTH and HEIGHT env vars for initial canvas size
- Shader class can take shadertoy frament shader source
- createGraphics() can take pixelDensity parameter
- Pass self to the block call of beginDraw(), and ensure endDraw


## [v0.5.14] - 2023-05-29

- Add windowMove() and windowResize()
- Add windowMoved(), windowResized(), and windowResizable()
- Add windowX() and windowY()
- Add displayWidth(), displayHeight(), pixelWidth(), pixelHeight(), and pixelDensity()
- Add doc for width() and height()
- Fix crash on calling size()


## [v0.5.13] - 2023-05-27

- pushMatrix(), pushStyle(), and push() return the result of the expression at the end of the block when a block given
- required_ruby_version >= 3.0.0
- Add spec.license


## [v0.5.12] - 2023-05-26

- pushStyle/popStyle do not manage filter state


## [v0.5.11] - 2023-05-21

- copy() and blend() now work with tint color


## [v0.5.10] - 2023-05-19

- Vector#array takes parameter for number of dimensions


## [v0.5.9] - 2023-05-18

- Update dependencies


## [v0.5.8] - 2023-05-13

- Update dependencies


## [v0.5.7] - 2023-05-11

- Add examples/shake.rb
- Fix Vector.random2D() not working correctly when angleMode is set to DEGREES


## [v0.5.6] - 2023-05-08

- Add inspect() to classes
- Alias draw methods
- colorMode(), angleMode(), and blendMode() returns current mode value
- fix that mouseButton returns 0 on mouseReleased


## [v0.5.5] - 2023-04-30

- Update documents


## [v0.5.4] - 2023-04-25

- Update reflex to v0.1.34


## [v0.5.3] - 2023-04-22

- Delete RubyProcessing.podspec
- Do not depend on Beeps
- If there are no user blocks, the window is not displayed and exits


## [v0.5.2] - 2023-03-02

- delete rubysketch.rb and rubysketch-processing.rb


## [v0.5.1] - 2023-03-01

- requiring 'rubysketch-processing' is deprecated


## [v0.5.0] - 2023-02-09

- requiring 'processing/include' is deprecated
- require 'processing' and 'using Processing' is now required
- do not show the window if a draw block is not given


## [v0.4.0] - 2022-12-29

- renamed from rubysketch.gem to processing.gem
- renamed from RubySketch Pod to RubyProcessing Pod
- delete glsl mode


## [v0.3.22] - 2022-11-14

RubySketch::Processing
- add Shader class
- add shader(), resetShader(), createShader(), loadShader(), and filter()
- update the pixel density of context if the screen pixel density is changed
- setUniform() can also take array of numbers, vector, and texture image.
- pushStyle() manages states of textAlign, tint, and filter
- push/pushMatrix/pushStyle call pop() on ensure

RubySketch::GLSL
- displays with pixel density 1.0


## [v0.3.21] - 2022-09-05

- add rubysketch-glsl.rb
- add blend(), createImage(), setTitle(), tint() and noTint()
- add save() that saves screen image to file
- circle() function is affected by ellipseMode()
- point() draws by line(x, y, x, y)
- change initial values for strokeCap and strokeJoin to ROUND and MITER


## [v0.3.20] - 2022-07-24

- add mouseClicked()
- add blendMode()
- add clip() and noClip()
- translate() can take 'z' parameter
- fix that resizing canvas consumes too much memory


## [v0.3.19] - 2021-12-5

- fix runtime error


## [v0.3.18] - 2021-12-5

- add 'mouseButton'
- pointer cancel event calls pointer_up block


## [v0.3.17] - 2021-12-5

- add Touch#id


## [v0.3.16] - 2021-2-14

- add key, keyCode and keyPressed system values
- add keyPressed(), keyReleased() and keyTyped() functions
- add motionGravity value and motion() function


## [v0.3.15] - 2020-12-12

- delete temporary directory on launch


## [v0.3.14] - 2020-12-12

- fix loadImage() fails when Encoding.default_internal is not nil


## [v0.3.13] - 2020-12-12

- size(), createCanvas(): default pixelDensity is same as current value


## [v0.3.12] - 2020-12-10

- size() and createCanvas() take 'pixelDensity' parameter and default value is 1


## [v0.3.11] - 2020-12-9

- add size(), createCanvas() and pixelDensity()


## [v0.3.10] - 2020-12-1

- invert angle parameter value for arc() to fix compatibility to processing API


## [v0.3.9] - 2020-11-30

- Graphics#beginDraw() can take block to call endDraw automatically
- Capture#start() always returns nil
- add delay_camera.rb


## [v0.3.8] - 2020-11-27

- Capture#initialize() can take requestWidth, requestHeight and cameraName
- add Capture#width and Capture#height


## [v0.3.7] - 2020-11-18

- add Capture class
- add log(), exp(), sqrt() and PI
- add examples/camera.rb
- add examples/breakout.rb
- fix error on calling image()


## [v0.3.6] - 2020-08-02

- random() can take array or nothing
- use github actions to release gem package


## [v0.3.5] - 2020-08-02

- add random()
- add sin(), cos(), tan(), asin(), acos(), atan() and atan2()
- make Vector class accessible from user script context
- fix error on calling rotate()


## [v0.3.4] - 2020-08-02

- delete Utility module


## [v0.3.3] - 2020-08-01

- add Vector class


## [v0.3.2] - 2020-07-22

- text() draws to the baseline by default
- add textWidth(), textAscent(), textDescent() and textAlign()
- change initial color for fill() and stroke()
- change initial background color to grayscale 0.8


## [v0.3.1] - 2020-07-17

- add touchStarted(), touchEnded(), touchMoved() and touches()
- make all event handler drawable
- limit font max size to 256


## [v0.3.0] - 2020-05-21

- add createGraphics()


## [v0.2.7] - 2020-04-17

- add strokeCap() and strokeJoin()


## [v0.2.6] - 2020-04-17

- push(), pushMatrix() and pushStyle() take block to automatic pop
- refine startup process
- add curve() and bezier()
- add imageMode(), Image#resize(), Image#copy() and copy()
- add loop(), noLoop() and redraw()


## [v0.2.5] - 2020-03-29

- delete debug prints
- show unsupported image type
