#!/usr/bin/env ruby

#load the library
require "miniparse"

#create the parser
parser = Miniparse::Parser.new

#define interface
parser.add "--debug", false, "activate debug"
parser.add "--verbose"

                     # parser.options.each { |o|  p o.name } 

#parse command line
args = parser.parse ARGV

#see results
puts "Options:"
p parser.options_status
puts "Args:"
p args

                    #  puts parser.msg_help
puts "Done."
