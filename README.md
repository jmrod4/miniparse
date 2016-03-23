
# miniparse [![Gem version](https://img.shields.io/gem/v/miniparse.svg)](https://rubygems.org/gems/miniparse)

**Miniparse is an easy to use yet flexible and powerful Ruby library for parsing command-line options.**


The main objective of this implementation is to get minimun boiler plate but keep ease of use and a self documenting specification. 

Additionally the library is quite flexible and allows a lot of customization but always with sane defaults so **you don't need to learn nothing to start using it**.

## How to Use

Please find below a short but meaningful example, then you can **[get more examples](https://github.com/jmrod4/miniparse/tree/master/examples)** at [Github miniparse repository](https://github.com/jmrod4/miniparse).

You can also find a nice autogenerated documentation from the current gem at  http://www.rubydoc.info/gems/miniparse/

And finally, the source files for the complete public interface are:

  * the class Parser at [miniparse/parser.rb](https://github.com/jmrod4/miniparse/blob/master/lib/miniparse/parser.rb)

  * the control class methods at [miniparse/control.rb](https://github.com/jmrod4/miniparse/blob/master/lib/miniparse/control.rb)
  
  * the constants in [miniparse/constants.rb](https://github.com/jmrod4/miniparse/blob/master/lib/miniparse/constants.rb)
  
  * and if you use the optional App module you can find the source in [miniparse/app.rb](https://github.com/jmrod4/miniparse/blob/master/lib/miniparse/app.rb)		

## Simple Example

Let's try putting the following code in `myprogram.rb`

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

    $ ruby myprogram.rb

    run silently

or run
    
    $ ruby myprogram.rb --debug
    
    DEBUG ACTIVATED!

or even get the auto generated help
    
    $ ruby yourprogram.rb --help
    
    usage: ex01_simple.rb [--help] [--debug] <args>

    Options:
       --debug          activate debugging
	   
## Installation

You can install it as an standard Ruby gem with

    $ gem install miniparse
    
then to use you can require it adding the following to the top of your Ruby source file

    require 'miniparse'
	
## FAQ

There is a FAQ available at https://github.com/jmrod4/miniparse/blob/master/FAQ.md
    
## Contributing

Bug reports and pull requests are most welcome at https://github.com/jmrod4/miniparse.

After checking out the repo you can:

 * run `bin/setup` to install dependencies
 * then run `rake test` to run the tests
 * you can also run `bin/console` for an interactive prompt that will allow you to experiment
 * run `bundle exec miniparse` to use the gem in this directory, ignoring other installed copies of this gem
 * run `rake -T` to see the rake tasks defined

## License

Copryright 2016 Juanma Rodriguez

This library is copyrighted software and it can be used and distributed as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

You can find the source code at https://github.com/jmrod4/miniparse.
