require 'miniparse'

parser = Miniparse::Parser.new

# if add_option has a block it will execute (at .parse) only when the option 
# is specified in the parsed line command (i.e. argv)
# the block will recive the option user specified value (a string) as argument 
parser.add_option("--kill THING", "kill something") do |val|
  puts "Die #{val}! DIE!"
end 

parser.add_command("list", nil)

parser.add_command(:fly, "do an incredible approximate simulation of flying") do
  puts "Look Ma! No hands!"
end 
parser.add_option("--high", "set your flying level high")


# the blocks for the options or commands specified in ARGV will be executed now
parser.parse(ARGV)

# show results with the current used command line
# for global options
puts "args     #{parser.args.inspect}"
puts "options  #{parser.options.inspect}"
# for commands
puts "parsed command  #{parser.parsed_command.inspect}"
puts "command args    #{parser.command_args.inspect}"
puts "command options #{parser.command_options.inspect}"
