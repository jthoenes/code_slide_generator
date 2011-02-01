$:.unshift File.join(File.dirname(__FILE__))
require 'lib/commands/base'
require "lib/commands/add"
require "lib/commands/bold"
require "lib/commands/delete"
require "lib/commands/red"
require "lib/commands/unwhite"
require "lib/commands/white"
require "lib/commands/start"

require 'lib/parser'
require 'lib/code_parser'
require "lib/xml_parser"
require 'lib/tag_item'
require 'lib/text_item'
require 'lib/formattable_text'

filepath = ARGV.first
raise "File '#{filepath}' not found" unless File.exists?(filepath)

text = File.read ARGV.first


parser = case (filepath.split('.').last)
           when 'as'
           when 'java'
             CodeParser.new(text)
           when 'xml'
             XMLParser.new(text)
           else
             raise "Not valid file format for #{filepath}"
         end


max_slide_number, formattable_texts = parser.parse

0.upto(max_slide_number) do |slide_number|
  puts "#" * 50
  puts "## SLIDE #{slide_number}"
  puts "#" * 50
  formattable_texts.each { |ft| ft.apply(slide_number, nil) }
end

