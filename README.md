# Miniparse

**Miniparse is a easy of use yet flexible and powerful ruby library for parsing command-line options.**

The main objetive is ease of use and flexibility so the specification is self-documenting. The library allows a lot of customization but with sane defaults so **you don't need to learn nothing to start using it**.

## How to use

You can get full documentation in [Github jmrod4/miniparse](https://github.com/jmrod4/miniparse) but please find below a short and fast example.

Let's try putting the following code in `yourprogram.rb`

    require 'miniparse'
    
    parser = Miniparse::Parser.new
    parser.add_option "--debug", "activate debugging"
    parser.parse ARGV
    
    if parser.options[:debug]
      puts "DEBUG ACTIVATED!"
    else
      puts "run silently"
    end
    
Now you can run

    $ ruby yourprogram.rb

    run silently

or run
    
    $ ruby yourprogram.rb --debug
    
    DEBUG ACTIVATED!

or even get the auto generated help
    
    $ ruby yourprogram.rb --help
    
    usage: yourprogram [--[no-]debug] <args>
    
      --debug        activate debugging
      
## Installation

You can install it as an standard ruby gem with

    $ gem install miniparse
    
then to use it add to the top of your ruby source file

    require 'minparse'
    
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jmrod4/miniparse.

After checking out the repo you can

 * run `bin/setup` to install dependencies
 * then run `rake test` to run the tests
 * you can also run `bin/console` for an interactive prompt that will allow you to experiment
 * run `bundle exec miniparse` to use the gem in this directory, ignoring other installed copies of this gem
 * run `rake -T` to see the rake tasks defined

## License

This library is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

You can find the source code at https://github.com/jmrod4/miniparse.




