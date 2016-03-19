require 'miniparse'

parser = Miniparse::Parser.new

parser.add_option("--sort", "always sort the output", 
    shortable: true)

# a negatable option can be specified as '--option' or '--no-option'    
parser.add_option("--pill", "just a silly option", 
    shortable: true, negatable: true)
    
# if description is nil, then the option won't appear in the help description, only in the usage string
parser.add_option("--debug", nil)

# for switches the default will be evaluated to true or false
# for switch the default will be always false unless specified
parser.add_option("--normal", "run normally", default: true)

# for flags the typical default could be a string
parser.add_option("--verbose LEVEL", nil, default: "0")

parser.parse(ARGV)

# show results with the current used command line
# for global options
puts "args     #{parser.args.inspect}"
puts "options  #{parser.options.inspect}"
# for commands
puts "parsed command  #{parser.command.inspect}"
puts "command args    #{parser.command_args.inspect}"
puts "command options #{parser.command_options.inspect}"
