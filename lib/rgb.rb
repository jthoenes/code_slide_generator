class RGB

  RED_MULT = "10000".hex
  GREEN_MULT = "100".hex
  BLUE_MULT = "1".hex
  
  def self.from_rgb_value rgb_value
    red = rgb_value/RED_MULT
	green = (rgb_value%RED_MULT)/GREEN_MULT
	blue = ((rgb_value%RED_MULT)%GREEN_MULT)/BLUE_MULT
	
	new(red, green, blue)
  end

  def initialize red,green,blue
    @red, @green, @blue = red, green, blue
  end
  
  def to_rgb_value
    RED_MULT*@red + GREEN_MULT*@green + BLUE_MULT*@blue;
  end

end