#!/usr/bin/env ruby

#load the library
require "miniparse"

#create the parser
parser = Miniparse::Parser.new

#define interface
parser.add "--verbose"
parser.add "--debug", "activate debug", default:false

                     # parser.options.each { |o|  p o.name } 

#parse command line
args = parser.parse ARGV

#see results
puts "Options:"
p parser.options
puts "Args:"
p args

                    #  puts parser.msg_help
puts "Done."
