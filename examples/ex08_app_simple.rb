require "miniparse/app"

# the help introduction can be omitted 
App.configure_parser("my program help introduction\n") do |parser|
  Miniparse.set_control(
      autoshortable: true,
      )
  parser.add_option("--list", "list something")
  parser.parse ARGV
end

# to see App.debug you have to specify the --debug option
# for example: 'ruby ex08_app_simple.rb --debug' 
App.debug App.options   # to stdout
App.info App.options    # to stdout
App.warn App.options    # to stderr
App.error App.options   # to stderr (note: it doesn't exit)

puts "parser object: #{App.parser}"

puts 'Done.'