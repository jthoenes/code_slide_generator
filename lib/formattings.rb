class Formattings

  def initialize list = []
    @list = list
  end
  
  def including slide_number, formattings
    new_list = @list.clone
	formattings.each do |formatting| 
	  new_list[slide_number] ||= []
	  new_list[slide_number] << formatting
	end
	Formattings.new(new_list)
  end
  
  def relevant_formats slide_number
    formats = {}
    formats_upto_slide(slide_number) do |format|
	  # later slides formattings will override earlier ones
	  formats[format.type] = format
	end
	formats_until_slide(slide_number) do |format|
	  # later slides formattings will override earlier ones
	  formats[format.type] = format
	end
	formats_at_slide(slide_number) do |format|
	  # formattings for this very slide will override anything else
	  formats[format.type] = format
	end
	
	formats.values
  end
  
  private
  def formats_upto_slide(slide_number, &block)
    return [] if slide_number+1 > @list.length
	
    @list[slide_number+1 .. @list.length].each do |formattings|
	  formattings.each do |formatting|
	    formatting.until_slide_formats.each(&block)
      end unless formattings.nil?
    end
  end
  
  def formats_until_slide(slide_number, &block)
    @list[0..slide_number].each do |formattings|
	  formattings.each do |formatting|
	    formatting.from_slide_formats.each(&block)
      end unless formattings.nil?
    end
  end
  
  def formats_at_slide(slide_number, &block)
    @list[slide_number].each do |formatting|
	   formatting.at_slide_formats.each(&block)
	end unless @list[slide_number].nil?
  end
  
  

end