require 'spec_helper'



describe Miniparse::Command do

  before :each do
    @spec = "list"
    @desc = "do some listings"
    @cmd = Miniparse::Command.new(spec: @spec, desc: @desc)
  end 
  
  it 's class should validate specification' do
    #Command.validate("list").should 
    # FIXME
  end
  
  it 's class can convert a specification to name' do
    #Command.spec_to_name("list").should 
    # FIXME
  end
  
  it 'has a name' do
    #@cmd.name.should 
    # FIXME
  end
  
  it 'has a description' do 
    @cmd.desc.should include(@desc)
  end
  
  it 'can run it\'s attached block' do
    # FIXME
  end
  
  it 'can check an argument to see if it matches with it' do
    #@cmd.check("list").should
    # FIXME
  end
    
  it 'has a descriptive help text' do
    #@cmd.help_desc.should
    # FIXME
  end
  
end



describe Miniparse::Option do

  it 'has a value' do
    # FIXME
  end
  
  it 'is shortable or not' do
    # FIXME
  end
  
  it 'can parse an argument to its value' do
    # FIXME
  end
  
end



describe Miniparse::SwitchOption do

  it 's class can convert an specification to a name' do
    # FIXME
  end
  
  before :each do
    @spec = "--verbose"
    @desc = "sets the application verbosity"
    @opt = Miniparse::SwitchOption.new(spec: @spec, desc: @desc)
  end

  it 'can convert an argument to a value' do
    # FIXME
  end

  it 'has a usage help text' do
    # FIXME
  end
  
end



describe Miniparse::FlagOption do

  it 's class can convert an specification to a name' do
    # FIXME
  end
  
  before :each do
    @spec = "--verbose VALUE"
    @desc = "sets the application verbosity"
    @opt = Miniparse::FlagOption.new(spec: @spec, desc: @desc)
  end

  it 'can check an argument to see if it matches with it' do
    # FIXME
  end
  
  it 'can convert an argument to a value' do
    # FIXME
  end

  it 'has a usage help text' do
    # FIXME
  end
  
end



