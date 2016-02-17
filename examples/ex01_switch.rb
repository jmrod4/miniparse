#!/usr/bin/env ruby

#load the library
require "miniparse"

#create the parser
parser = Miniparse::Parser.new

#define interface
parser.add "--debug", false, "activate debug"
parser.add "--verbose LEVEL"

                     parser.options.each { |o|  p o.name } 

#parse command line
parser.parse ARGV

#see results
p parser.options_parsed

                    #  puts parser.msg_help
puts "Done."
