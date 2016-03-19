require 'spec_helper'



shared_examples :commandable do

  it 'responds to commandable interface' do
    expect(@obj.class).to respond_to :spec_to_name
    expect(@obj.class).to respond_to :valid_spec
    expect(@obj).to respond_to :name
    expect(@obj).to respond_to :desc
    expect(@obj).to respond_to :run
    expect(@obj).to respond_to :help_desc
    expect(@obj).to respond_to :check
  end

  it 'has a name' do
    expect(@spec.to_s).to include @obj.name.to_s
  end

  it 'has a description' do 
    expect(@obj.desc).to include @desc
  end

  it 'has a descriptive help text' do
    desc = @obj.help_desc
    expect(desc).to include @obj.name.to_s
    @obj.desc.split(/\s/).each do |part|
      expect(desc).to include part
    end
  end
  
  it "can run it's attached block with arguments" do
    arg = "doit"
    expect(@obj.run(arg)).to eq arg
    expect(@run_argument).to eq arg
  end

end



describe Miniparse::Command do

  before :each do
    @spec = "verbose"
    @desc = "do something with many words"
    @run_argument = nil
    @obj = Miniparse::Command.new(spec: @spec, desc: @desc) do |any|
      @run_argument = any
    end
  end 
  
  include_examples :commandable
  
  it "its class can convert from specification to name" do
    expect(@obj.class.spec_to_name("other")).to be :other
    expect(@obj.class.spec_to_name("--other")).to be nil
    expect(@obj.class.spec_to_name("--other VALUE")).to be nil
    expect(@obj.class.spec_to_name("--other=VALUE")).to be nil
    expect(@obj.class.spec_to_name("other=VALUE")).to be nil
    expect(@obj.class.spec_to_name(:other)).to be :other
    expect(@obj.class.spec_to_name("other ")).to be nil
    expect(@obj.class.spec_to_name(" other")).to be nil
    expect(@obj.class.spec_to_name("oth er")).to be nil
    expect(@obj.class.spec_to_name("-o")).to be nil
    expect(@obj.class.spec_to_name("")).to be nil
  end
  
  it "its class can validate a specification" do
    expect(@obj.class.valid_spec("other")).to be_truthy
    expect(@obj.class.valid_spec(:other)).to be_truthy
    expect(@obj.class.valid_spec("o")).to be_truthy
    expect(@obj.class.valid_spec("--other")).to be_falsy
    expect(@obj.class.valid_spec("-o")).to be_falsy
  end
  
  it 'can check an argument to see if it matches with it' do
    expect(@obj.check("verbose")).to be_truthy
    expect(@obj.check("--verbose")).to be_falsy
    expect(@obj.check("--verbose VALUE")).to be_falsy
    expect(@obj.check("--verbose=VALUE")).to be_falsy
  
    expect(@obj.check(:verbose)).to be_truthy
    expect(@obj.check("other")).to be_falsy
    expect(@obj.check("ver")).to be_falsy
    expect(@obj.check("v")).to be_falsy
    expect(@obj.check("verbose ")).to be_falsy
    expect(@obj.check(" verbose")).to be_falsy
    expect(@obj.check("verb ose")).to be_falsy
  end
  
end



shared_examples :optionable do

  it 'responds to optionable interface' do
    expect(@obj.respond_to? :value).to be_truthy
    expect(@obj.respond_to? :shortable).to be_truthy
    expect(@obj.respond_to? :arg_to_value).to be_truthy
    expect(@obj.respond_to? :parse_value).to be_truthy
    expect(@obj.respond_to? :help_usage).to be_truthy
  end

  it 'has a value' do
    @obj.value
  end
  
  it 'is shortable or not' do
    @obj.shortable
  end
  
  it 'has a usage help text' do
    expect(@obj.help_usage).to match /--.*verbose/
  end
end



describe Miniparse::SwitchOption do

  before :each do
    @spec = "--verbose"
    @desc = "sets the application verbosity"
    @run_argument = nil
    @obj = Miniparse::SwitchOption.new(spec: @spec, desc: @desc,
      negatable: true, shortable: false, default: false) do |val|
        @run_argument = val
    end
  end 

  include_examples :commandable
  include_examples :optionable

  it "its class can convert an specification to a name" do
    expect(@obj.class.spec_to_name("other")).to be nil
    expect(@obj.class.spec_to_name("--other")).to be :other
    expect(@obj.class.spec_to_name("--other VALUE")).to be nil
    expect(@obj.class.spec_to_name("--other=VALUE")).to be nil
  end
  
  it 'can parse an argument to its value and execute its block with value' do
    val = @obj.parse_value("--verbose")
    expect(val).to be_truthy
    expect(@obj.value).to eq val
    expect(@run_argument).to eq val
  end
  
  it 'can check an argument to see if it matches with it' do
    expect(@obj.check("verbose")).to be_falsy
    expect(@obj.check("--verbose")).to be_truthy
    expect(@obj.check("--verbose VALUE")).to be_falsy
    expect(@obj.check("--verbose=VALUE")).to be_falsy
  end
  
  it 'can convert from an argument to a value' do
    expect(@obj.arg_to_value("verbose")).to be nil
    expect(@obj.arg_to_value("--verbose")).to be_truthy
    expect(@obj.arg_to_value("--no-verbose")).not_to be nil
    expect(@obj.arg_to_value("--no-verbose")).to be_falsy
  end
    
end



describe Miniparse::FlagOption do

  before :each do
    @spec = "--verbose VALUE"
    @desc = "sets the application verbosity"
    @run_argument = nil
    @obj = Miniparse::FlagOption.new(spec: @spec, desc: @desc, 
      shortable: false, default: false) do |any|
      @run_argument = any
    end
  end 

  include_examples :commandable
  include_examples :optionable

  it "its class can convert an specification to a name" do
    expect(@obj.class.spec_to_name("other")).to be nil
    expect(@obj.class.spec_to_name("--other")).to be nil
    expect(@obj.class.spec_to_name("--other VALUE")).to be :other
    expect(@obj.class.spec_to_name("--other=VALUE")).to be :other
  end
  
  it 'can check an argument to see if it matches with it' do
    expect(@obj.check("verbose")).to be_falsy
    expect(@obj.check("--verbose")).to be_truthy
    expect(@obj.check("--verbose VALUE")).to be_truthy
    expect(@obj.check("--verbose=VALUE")).to be_truthy
  end
  
  it 'can convert an argument to a value' do
    expect(@obj.arg_to_value("verbose")).to be nil
    expect(@obj.arg_to_value("--verbose")).to be nil
    expect(@obj.arg_to_value("--no-verbose")).to be nil
    expect(@obj.arg_to_value("--verbose VALUE")).to eq "VALUE"
    expect(@obj.arg_to_value("--verbose=VALUE")).to eq "VALUE"
    expect(@obj.arg_to_value("verbose VALUE")).to be nil
    expect(@obj.arg_to_value("--no-verbose VALUE")).to be nil
  end
end



