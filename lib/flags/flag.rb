module Flags
  class Flag
    attr_writer :width, :height

    def initialize(locale, url)
      @locale          = locale
      @url             = url
      @root_dir        = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
      @source_filepath = File.join(@root_dir, "source", "#{@locale}.svg")
      @filepath        = File.join(@root_dir, "output", "#{@locale}.png")
      @width           = 18
      @height          = 12
      @radius          = 2
      @stroke          = 1
    end

    def process!
      puts '-'*80
      puts "- #{@locale}, #{@width}x#{@height}"
      puts '-- cacheing';     cache!
      puts '-- converting';   convert!
      puts '-- rounding';     round!
      puts '-- highlighting'; highlight!
      puts '-- strokeing';    stroke!
    end

    def cache!
      FileUtils.mkdir_p(File.join(@root_dir, 'source'))
      FileUtils.mkdir_p(File.join(@root_dir, 'output'))
      return if File.exist?(@source_filepath)
      img = open(@source_filepath, "wb")
      img.write(open(@url).read)
      img.close
    end

    def convert!
      img = Magick::Image.read(@source_filepath).first
      img.crop_resized!(@width, @height, Magick::CenterGravity)
      img.write(@filepath)
    end

    def round!
      img  = Magick::Image.read(@filepath).first
      mask = Magick::Image.new(@width, @height) { self.background_color = 'transparent' }
      Magick::Draw.new.stroke('none').
        stroke_width(0).
        fill('white').
        roundrectangle(0, 0, @width-1, @height-1, @radius, @radius).
        draw(mask)
      img.composite!(mask, 0, 0, Magick::CopyOpacityCompositeOp)
      img.write(@filepath)
    end

    def highlight!
      img = Magick::Image.read(@filepath).first
      Magick::Draw.new.fill('#fff').
        fill_opacity('50%').
        roundrectangle(@stroke*2, @stroke*2, @width-@stroke*2-1, @height/2, @radius, @radius).
        draw(img)
      img.write(@filepath)
    end

    def stroke!
      img = Magick::Image.read(@filepath).first
      Magick::Draw.new.stroke('#000').
        stroke_width(1).
        stroke_opacity('30%').
        fill_opacity('0%').
        roundrectangle(0, 0, @width-1, @height-1, @radius, @radius).
        draw(img)
      img.write(@filepath)
    end
  end
end