
# Miniparse Change Log
All MAJOR.MINOR changes to Miniparse will be documented in this file.
This project uses an aproximation to [Semantic Versioning](http://semver.org/), 
see [miniparse FAQ](https://github.com/jmrod4/miniparse/blob/master/FAQ.md) for details.
 

## [v0.4.0.pre] - (testing) 

### Public interface
to gain in clarity
- Parser#command_name replaces Parser#command
- Parser#current_command_name replaces Parser#current_command

new feature
- added Parser#add_program_description

### Improved
- greatly improved source yard documentation (used by rubygems site) and used @private to guard the non-public interface
- improved examples

### Fixed
- added gemspec requeriment to Ruby 2.0 or later
- fixed examples

## [v0.3.0] - 2016-03-16
first public gem release
