require 'miniparse'

parser = Miniparse::Parser.new

# if description is nil the command will appear in the help as "other commands"
parser.add_command("list", nil)

# you can use symbol or string to specify a command
parser.add_command(:fly, "don't actually fly, just do an incredible approximate simulation")

# this option is NOT global, but only applicable to the last specified command
# ('fly' in this case)
parser.add_option("--high", "set your flying level high")

parser.parse(ARGV)

# show results with the current used command line
# for global options
puts "args     #{parser.args.inspect}"
puts "options  #{parser.options.inspect}"
# for commands
puts "parsed command  #{parser.command_name.inspect}"
puts "command args    #{parser.command_args.inspect}"
puts "command options #{parser.command_options.inspect}"
