$:.unshift File.dirname($0)
require 'lib/loader'

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
  opt :formattings, "custom DSL file for the formatting commands", :type => :string, :default => "#{File.dirname($0)}/lib/default_formattings.rb"
end

Trollop::die :slide, "please provide a --slide or use --all" unless opts[:all] || opts[:slide]
Trollop::die :slide, "must be a positive integer" unless opts[:slide].nil? || opts[:slide] > 0
Trollop::die :path, "must be a valid path to a directoy" unless opts[:path].length == 0 || File.directory?(opts[:path])
Trollop::die :path, "must be a valid path to a file" unless opts[:formattings].length == 0 || File.exists?(opts[:formattings])

FormattingDSL.module_eval(File.read(opts[:formattings]))

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
