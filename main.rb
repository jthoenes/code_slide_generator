$:.unshift File.join(File.dirname(__FILE__))
require 'win32ole'
require 'open-uri'
require 'rubygems'
require 'trollop'

require 'lib/commands/base'
require 'lib/commands/add'
require 'lib/commands/bold'
require 'lib/commands/delete'
require 'lib/commands/red'
require 'lib/commands/unwhite'
require 'lib/commands/white'
require 'lib/commands/start'

require 'lib/parser'
require 'lib/code_parser'
require 'lib/xml_parser'
require 'lib/tag_item'
require 'lib/text_item'
require 'lib/formattable_text'

require 'lib/power_point'
require 'lib/power_point/application'
require 'lib/power_point/presentation'
require 'lib/power_point/slide'
require 'lib/power_point/shape'
require 'lib/power_point/text_range'

opts = Trollop::options do
  version "Code Slide Generation 0.1.0a (c) 2011 Johannes Thönes <johannes.thoenes@cgm.com>"
  banner <<-EOS
A Generator for Slides containing Code in PowerPoint.

Usage:
	code_slide_generate [options]

where [options] are:
EOS

  opt :all, "generate all slides", :default => false
  opt :slide, "slide Number which should be (re-)generated", :type => :int
  opt :path, "base path for the slides", :type => :string
end

Trollop::die :slide, "please provide a --slide or use --all" unless opts[:all] || opts[:slide]
Trollop::die :slide, "must be a positive integer" unless opts[:slide] > 0
Trollop::die :path, "must be a valid path to a directoy" unless opts[:path].nil? || File.directory?(opts[:path])

slide_only = opts[:slide]
basepath = opts[:path]

power_point = PowerPoint::Application.new
presentation = power_point.current_presentation

code_slides = presentation.code_slides
code_slides.reject!{|slide| slide.number != slide_only} if slide_only

code_slides.each do |slide|
  #p slide.subsequent_generated_slides.each(&:delete)
end


if slide_only.nil?
  presentation.slides.select(&:generated?).each(&:delete)
else 
  to_delete = []
  slide_number = slide_only
  loop do
    slide = presentation.slides[slide_number]
	if slide.generated?
	  to_delete << slide
	else
	  break
	end
	slide_number += 1
  end
  to_delete.each(&:delete)
end


code_shapes = presentation.select_shapes do |shape|
  shape.code_shape?
end.map

code_shapes.map(&:slide).each(&:hide!)

code_shapes.each do |shape|
  next unless slide_only.nil? or shape.slide.number == slide_only

  filepath = shape.code_filepath(basepath)
  
  
  text = ""
  begin
    open(filepath) {|f| f.each_line {|line| text += line }}
  rescue
    raise "Cannot read Input Source '#{filepath}' from Slide #{shape.slide.number}"
  end
  
  parser = case (filepath.split('.').last)
           when 'as', 'java', 'cs'
             CodeParser.new(filepath, text)
           when 'xml'
             XMLParser.new(filepath, text)
           else
             raise "Not valid file format for #{filepath}"
         end
		 
  max_slide_number, formattable_texts = parser.parse

  slide_range = shape.calculate_range(max_slide_number)
  
  current_slide = shape.slide
  slide_range.each do |slide_number|
    current_slide = current_slide.duplicate
	current_slide.show!
	current_shape = current_slide.shapes[shape.index]
	current_shape.prepare!
	
    formattable_texts.each { |ft| ft.apply(slide_number, current_slide, current_shape) }
  end
  shape.slide.select! unless slide_only.nil?
end
