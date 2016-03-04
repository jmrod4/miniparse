require 'spec_helper'

describe Miniparse::OptionBroker do

  before :each do
    @broker = Miniparse::OptionBroker.new
  end
  
  it 'has parsed values' do
    expect(@broker.respond_to?(:parsed_values)).to be_truthy
  end
  
  it 'can add an option' do
    expect(@broker.respond_to?(:add_option)).to be_truthy
  end

  it 'has a usage help text' do
    @broker.add_option(spec: "--verbose VALUE", desc: "many words")
    @broker.add_option(spec: "--sort", desc: "very ordered")
    usage = @broker.help_usage
    expect(usage).to include "verbose", "VALUE", "sort"
    expect(usage).not_to include "many", "words", "very", "ordered"
  end

  it 'has a descriptive help text' do
    @broker.add_option(spec: "--verbose VALUE", desc: "many words")
    @broker.add_option(spec: "--sort", desc: "very ordered")
    usage = @broker.help_desc
    expect(usage).to include "verbose", "VALUE", "sort"
    expect(usage).to include "many", "words", "very", "ordered"
  end

  describe :parse_argv do
    
    before :each do
      @broker = Miniparse::OptionBroker.new
      @spec = "--verbose"
    end
    
    it 'can parse an array of arguments (like ARGV)' do
      @broker.add_option(spec: @spec)
      res = @broker.parse_argv "a b --verbose c d".split
      "a b c d".split.each { |arg| expect(res).to include arg }
      expect(res).not_to include "--verbose"
    end

    it 'flag option consumes an aditional algument' do
      @broker.add_option(spec: "--verbose VALUE")
      res = @broker.parse_argv "a b --verbose c d".split
      "a b d".split.each { |arg| expect(res).to include arg }
      expect(res).not_to include "--verbose"
      expect(res).not_to include "c"
      expect(@broker.parsed_values[:verbose]).to eq "c"
    end
  
    it 'updates parsed values' do
      @broker.add_option(spec: @spec)
      expect(@broker.parsed_values[:verbose]).to be nil
      @broker.parse_argv ["--verbose"]
      expect(@broker.parsed_values[:verbose]).to be true
    end
  
    it 'option block will execute when successfully parsed' do
      a = nil 
      @broker.add_option(spec: @spec) { a = 10 }
      expect(a).to be nil
      @broker.parse_argv [@spec]
      expect(a).to eq 10
    end
  
    it "option block won't execute when parse failed" do
      Miniparse.set_control(
        raise_on_unrecognized: false,
        )
      a = nil 
      @broker.add_option(spec: @spec) { a = 10 }
      expect(a).to be nil
      @broker.parse_argv ["--other"]
      expect(a).to be nil
    end
    
    it 'can raise when parsing an unrecognized option' do
      Miniparse.set_control(
        raise_on_unrecognized: true,
        rescue_argument_error: false,
        )
      @broker.add_option(spec: @spec)
      expect { @broker.parse_argv ["--other"] }.to raise_error ArgumentError
    end

  end  

end