#/usr/bin/env ruby

require 'miniparse'

parser = Miniparse::Parser.new

parser.add_option("--debug", nil) do
  puts "Debug activated!"
end
parser.add_option("--file FILE", "file for storing the tasks", 
    default: "~/todos.txt")

parser.add_command(:new, "creates a new todo in the default location")

parser.add_command(:done, "complete a task")

parser.add_command(:list, "list tasks")
parser.add_option("--sort", "order everything!")

parser.parse ARGV

# show results with the current used command line
# for global options
puts "args     #{parser.args.inspect}"
puts "options  #{parser.options.inspect}"
# for commands
puts "parsed command  #{parser.parsed_command.inspect}"
puts "command args    #{parser.command_args.inspect}"
puts "command options #{parser.command_options.inspect}"

parser.try_argument do
  # I have no use for global args, so it has to be a mistaken command
  if !parser.args.empty?
    raise ArgumentError, "unrecognized command: '#{parser.args[0]}'"
  end
end


