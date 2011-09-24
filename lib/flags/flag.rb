module Flags
  class Flag
    def initialize(locale, url)
      @locale         = locale
      @url            = url
      @root_dir       =  __File
      @cache_filepath = File.join(@root_dir, "cache", "#{@locale.svg}")
      @filepath       = File.join(@root_dir, "output", "#{@locale}.png")
      @width          = 18
      @height         = 12
      @radius         = 3
    end

    def cache!
      return if File.exist?(@cache_filepath)
      img = open(@cache_filepath, "wb")
      img.write(open(@url).read)
      img.close
    end

    def convert!
      img = Magick::Image.read(@cache_filepath).first
      img.crop_resized!(@width, @height, Magick::CenterGravity)
      img.write(@filepath)
    end

    def round!
      img  = Image.read(@filepath).first
      mask = Image.new(@width, @height) { self.background_color = 'transparent' }
      Draw.new.stroke('none').
        stroke_width(0).
        fill('white').
        roundrectangle(0, 0, @width-1, @height-1, @radius, @radius).
        draw(mask)
      img.composite!(mask, 0, 0, Magick::CopyOpacityCompositeOp)
      img.write(@filepath)
    end

    def stroke!
      # img  = Image.read(out_filename).first
      # stroke = Image.new(width, height) { self.background_color = 'transparent' }
      # Draw.new.stroke('#000').
      #   stroke_width(1).
      #   stroke_opacity('50%').
      #   fill_opacity('0%').
      #   roundrectangle(0, 0, width-1, height-1, radius, radius).
      #   draw(stroke)
      # stroke.composite!(img, 0, 0, Magick::CopyOpacityCompositeOp)
      # stroke.write(out_filename)
    end

    def highlight!
      img  = Image.read(out_filename).first
      highlight = Image.new(width, height) { self.background_color = 'transparent' }
      Draw.new.stroke('#000').
        stroke_width(1).
        fill_opacity('70%').
        roundrectangle(0, 0, width-1, height-1, radius, radius).
        draw(stroke)
      img.composite!(highlight, 0, 0, Magick::CopyOpacityCompositeOp)
      img.write(out_filename)
    end
  end
end


flags = YAML.load_file('flags.yml')
flags.each do |locale, url|
  puts '*'*88
  flag = Flag.new(locale, url)
  p flag
  flag.cache!
  flag.convert!
  flag.round!
  flag.stroke!
  flag.hightlight!
end