require 'open-uri'
require 'ferrum'

RUBY_URL = 'https://cdn.jsdelivr.net/npm/ruby-3_2-wasm-wasi@next/dist/browser.script.iife.js'
P5JS_URL = 'https://cdn.jsdelivr.net/npm/p5@1.5.0/lib/p5.js'
P5RB_URL = 'https://raw.githubusercontent.com/ongaeshi/p5rb/421ce24c4a29c5787d143f8132eb610b73f60b92/docs/lib/p5.rb'

P5RB_SRC = URI.open(P5RB_URL) {|f| f.read}

def browser(width, height, headless: true)
  hash        = ($browsers ||= {})
  key         = [width, height, headless]
  hash[key] ||= Ferrum::Browser.new headless: headless, window_size: [width, height + 200]
end

def get_svg_html(width, height, svg_xml)
  <<~END
    <html>
      <head>
        <style type="text/css">
          body {margin: 0;}
        </style>
        <script type="text/javascript">
          window.onload = function() {
            let e = document.createElement("span");
            e.id = 'completed';
            document.body.appendChild(e);
          }
        </script>
      </head>
      <body>
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 #{width} #{height}">
          #{svg_xml}
        </svg>
      </body>
    </html>
  END
end

def get_p5rb_html(width, height, draw_src, webgl: false)
  <<~END
    <html>
      <head>
        <script src="#{RUBY_URL}"></script>
        <script src="#{P5JS_URL}"></script>
        <script type="text/ruby">#{P5RB_SRC}</script>
        <style type="text/css">
          body {margin: 0;}
        </style>
        <script type="text/javascript">
          function completed() {
            id = 'completed'
            if (document.querySelector("#" + id)) return;
            let e = document.createElement("span");
            e.id = id;
            document.body.appendChild(e);
          }
        </script>
        <script type="text/ruby">
          def setup()
            createCanvas #{width}, #{height}#{webgl ? ', WEBGL' : ''}
          end
          def draw()
            #{webgl ? 'translate -width / 2, -height / 2' : ''}
            #{draw_src}
            JS.global.completed
          end
          P5::init
        </script>
      </head>
      <body><main></main></body>
    </html>
  END
end

def sleep_until(try: 3, timeout: 10, &block)
  now = -> offset = 0 {Time.now.to_f + offset}
  limit = now[timeout]
  until block.call
    if now[] > limit
      limit = now[timeout]
      try -= 1
      next if try > 0
      raise 'Drawing timed out in browser'
    end
    sleep 0.1
  end
end

def draw_on_browser(width, height, path, html, headless: true)
  b = browser width, height, headless: headless
  unless File.exist? path
    b.reset
    b.main_frame.content = html
    sleep_until do
      b.evaluate 'document.querySelector("#completed") != null'
    end
    b.screenshot path: path, area: {x: 0, y: 0, width: width, height: height}
  end
  sleep 1
  b.device_pixel_ratio
end

def draw_svg(width, height, svg_xml, path, headless: true)
  html = get_svg_html width, height, svg_xml
  draw_on_browser width, height, path, html, headless: headless
end

def draw_p5rb(width, height, draw_src, path, headless: true, webgl: false)
  html = get_p5rb_html width, height, draw_src, webgl: webgl
  draw_on_browser width, height, path, html, headless: headless
end
