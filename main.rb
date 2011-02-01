$:.unshift File.join(File.dirname(__FILE__))
require 'lib/parser'

text = File.read ARGV.first
Parser.new text
