module RubySketch


  module Module

    module_function

    def name()
      super.split('::')[-2]
    end

    def version()
      open(root_dir 'VERSION') {|f| f.readline.chomp}
    end

    def root_dir(path = '')
      File.expand_path "../../#{path}", __dir__
    end

  end# Module


end# RubySketch
