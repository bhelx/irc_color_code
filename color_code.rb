require 'Rmagick'

class MircColor < Struct.new(:r, :g, :b)
  PIXEL_SCALE = Magick::QuantumRange / 255.0
  COLORS = [
    MircColor.new(255,255,255),
    MircColor.new(0,0,0),
    MircColor.new(0,0,127),
    MircColor.new(0,147,0),
    MircColor.new(255,0,0),
    MircColor.new(127,0,0),
    MircColor.new(156,0,156),
    MircColor.new(252,127,0),
    MircColor.new(255,255,0),
    MircColor.new(0,252,0),
    MircColor.new(0,147,147),
    MircColor.new(0,255,255),
    MircColor.new(0,0,252),
    MircColor.new(255,0,255),
    MircColor.new(127,127,127),
    MircColor.new(210,210,210)
  ].freeze

  def self.closest_to(pixel)
    COLORS.min_by { |color| color.distance(pixel) }
  end

  def distance(pixel)
    pixel_channels = [:red, :green, :blue].map { |chan| pixel.send(chan) / PIXEL_SCALE }
    Math.sqrt([r, g, b].zip(pixel_channels).map { |x| (x[1] - x[0])**2 }.reduce(:+))
  end

  def to_s
    color = COLORS.index(self)
    "\C-c#{color},#{color}x\C-c"
  end
end

image = Magick::Image.read(ARGV[0]).first
image.scale!(50, 50)

pixels = image.get_pixels(0, 0, image.columns, image.rows)

image.rows.times do |row|
  image.columns.times do |column|
    pixel = pixels[(row * image.columns) + column]
    mirc_color = MircColor.closest_to(pixel)
    print mirc_color
  end
  print "\n"
end

