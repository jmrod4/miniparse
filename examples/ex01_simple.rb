# example from the project readme
    
require 'miniparse'

parser = Miniparse::Parser.new
parser.add_program_description "my program help msg introduction\n"
parser.add_option "--debug", "activate debugging"
parser.parse ARGV

if parser.options[:debug]
  puts "DEBUG ACTIVATED!"
else
  puts "run silently"
end

# show results with the current used command line
# for global options
puts "args     #{parser.args.inspect}"
puts "options  #{parser.options.inspect}"
# for commands
puts "parsed command  #{parser.command_name.inspect}"
puts "command args    #{parser.command_args.inspect}"
puts "command options #{parser.command_options.inspect}"