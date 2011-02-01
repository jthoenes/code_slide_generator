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
require 'lib/tag_item'
require 'lib/text_item'
require 'lib/formattable_text'

text = File.read ARGV.first
Parser.new(text).parse
