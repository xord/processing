require 'rubysketch'


RubySketch.__send__ :start_on_object_at_exit, self, RubySketch::Processing.new
