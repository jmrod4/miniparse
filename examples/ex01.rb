require 'miniparse'

parser = Miniparse::Parser.new

parser.add_option("--debug", nil, default:false)
parser.add_option("--sort", "sorted output always")
parser.add_option("--verbose LEVEL", nil, default:0)
parser.add_option("--kill THING", "kill something") do |val|
  puts "Die #{val}! DIE!"
end 

parser.add_command("list", nil)

parser.add_command(:fly, "don't actually fly, just do an incredible approximate simulation")
parser.add_option("--high", "set your flying level high")

parser.parse(ARGV)

puts "args     #{parser.args.inspect}"
puts "options  #{parser.options.inspect}"
puts "parsed command  #{parser.parsed_command.inspect}"
puts "command args    #{parser.command_args.inspect}"
puts "command options #{parser.command_options.inspect}"
puts "parser  #{parser.inspect}"
