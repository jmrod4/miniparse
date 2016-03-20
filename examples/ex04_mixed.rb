require 'miniparse'

parser = Miniparse::Parser.new

parser.add_option("--sort", "always sort the output", shortable: true)
parser.add_option("--pilly", "just a silly option", shortable: true)

# if description is nil, then the option won't appear in the help description, only in the usage string
parser.add_option("--debug", nil)

# for switches the default will be evaluated to true or false
# for switch the default will be always false unless specified
parser.add_option("--normal", "run normally", default: true)

# for flags the typical default could be a string
parser.add_option("--verbose LEVEL", nil, default: "0")

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
