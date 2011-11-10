$:.unshift File.dirname($0)
require 'win32ole'
require 'open-uri'
require 'rubygems'
require 'trollop'

require 'lib/default_formattings'

require 'lib/parser'
require 'lib/code_parser'
require 'lib/xml_parser'
require 'lib/tag_item'
require 'lib/text_item'
require 'lib/formattable_text'
require 'lib/shape_formatter'

require 'lib/power_point'
require 'lib/power_point/application'
require 'lib/power_point/presentation'
require 'lib/power_point/slide'
require 'lib/power_point/shape'
require 'lib/power_point/text_range'

opts = Trollop::options do
  version "Code Slide Generation 0.1.0 (c) 2011 Johannes Thoenes <johannes.thoenes@cgm.com>"
  banner <<-EOS
A Generator for Slides containing Code in PowerPoint.

Usage:
	code_slide_generate [options]

where [options] are:
EOS

  opt :all, "generate all slides", :default => false
  opt :slide, "slide Number which should be (re-)generated", :type => :int
  opt :path, "base path for the slides", :type => :string, :default => ""
end

Trollop::die :slide, "please provide a --slide or use --all" unless opts[:all] || opts[:slide]
Trollop::die :slide, "must be a positive integer" unless opts[:slide].nil? || opts[:slide] > 0
Trollop::die :path, "must be a valid path to a directoy" unless opts[:path].length == 0 || File.directory?(opts[:path])

power_point = PowerPoint::Application.new
presentation = power_point.current_presentation

code_slides = presentation.code_slides
 if opts[:slide]
  code_slides.reject!{|slide| slide.number != opts[:slide]}
  Trollop::die :slide, "slide #{opts[:slide]} is not a code slide" if code_slides.empty?
end

code_slides.each{ |s| s.subsequent_generated_slides.each(&:delete) }
code_slides.each(&:hide!)
code_slides.each{|s| s.generate_code_slides(opts[:path])}

# Slide selection
if opts[:slide]
  code_slides.first.select!
else
  presentation.slides.first.select!
end
