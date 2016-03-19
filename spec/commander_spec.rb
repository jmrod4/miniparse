require 'spec_helper'

describe Miniparse::Commander do

  before :each do
    @cmdr = Miniparse::Commander.new
  end

  it 'has a public interface' do
    expect(@cmdr).to respond_to :current_command
    expect(@cmdr).to respond_to :parsed_command
    expect(@cmdr).to respond_to :parsed_args
    expect(@cmdr).to respond_to :parsed_values
    expect(@cmdr).to respond_to :current_broker
    expect(@cmdr).to respond_to :add_command
    expect(@cmdr).to respond_to :split_argv
    expect(@cmdr).to respond_to :parse_argv
    expect(@cmdr).to respond_to :help_desc
  end

  it 'can add a command' do
    expect(@cmdr.add_command(spec: :list)).not_to be nil
  end

  it 'keeps track of last added command' do
    expect(@cmdr.current_command).to be nil
    expect(@cmdr.add_command(spec: :list)).not_to be nil
    expect(@cmdr.current_command).to be :list
  end

  it 'keeps track of the current command option broker' do
    expect(@cmdr.current_broker).to be nil
    expect(@cmdr.add_command(spec: :list)).not_to be nil
    expect(@cmdr.current_broker).not_to be nil    
  end
  
  it 'can split an ARGV like to global part, found command name, and command parts' do
    expect(@cmdr.add_command(spec: :list)).not_to be nil
    expect(@cmdr.split_argv("".split)).to eq [[], nil, []]
    expect(@cmdr.split_argv("a".split)).to eq [["a"], nil, []]
    expect(@cmdr.split_argv("a list b".split)).to eq [["a"], :list, ["b"]]
    expect(@cmdr.split_argv("list b".split)).to eq [[], :list, ["b"]]
    expect(@cmdr.split_argv("list".split)).to eq [[], :list, []]
  end
  
  it 'can parse ARGV like arguments for a specified command (only args)' do
    expect(@cmdr.add_command(spec: :list)).not_to be nil
    only_args = ["a", "b"]
    expect(@cmdr.parse_argv(:list, only_args)).to eq only_args
  end
  
  it 'fills the parsed... methods when parsing (only args)' do
    expect(@cmdr.add_command(spec: :list)).not_to be nil

    expect(@cmdr.parsed_command).to be nil
    expect(@cmdr.parsed_args).to be nil
    expect(@cmdr.parsed_values).to be nil

    only_args = ["a", "b"]
    expect(@cmdr.parse_argv(:list, only_args)).to eq only_args

    expect(@cmdr.parsed_command).to be :list
    expect(@cmdr.parsed_args).to eq only_args
    expect(@cmdr.parsed_values).to eq({})
  end
  
  it "can't parse a non added command" do 
    expect(@cmdr.add_command(spec: :list)).not_to be nil
    only_args = ["a", "b"]
    expect {@cmdr.parse_argv(:sort, only_args)}.to raise_error KeyError 
  end 

  it "can parse built in help request via option --help" do 
    expect(@cmdr.add_command(spec: :list, desc: "my command description")).not_to be nil
    expect { @cmdr.parse_argv(:list, ["--help"]) }.to raise_error SystemExit
    expect { 
      begin
        @cmdr.parse_argv(:list, ["--help"])
      rescue SystemExit
      end 
      }.to output(/usage.+list/).to_stdout
  end  

  it "can parse built in help request via command help" do 
    expect(@cmdr.add_command(spec: :list, desc: "my command description")).not_to be nil
    expect { @cmdr.parse_argv(:help, ["list"]) }.to raise_error SystemExit
    expect { 
      begin
        @cmdr.parse_argv(:list, ["--help"])
      rescue SystemExit
      end 
      }.to output(/usage.+list/m).to_stdout
  end  

  it "knows the help message for it's commands" do
    expect(@cmdr.add_command(spec: :list, desc: "my command description")).not_to be nil
    expect(@cmdr.add_command(spec: :sort, desc: "alpha")).not_to be nil
    msg = @cmdr.help_desc
 
    expect(msg).to match /list.+description.+sort.+alpha.+help/m
    expect(msg).not_to match /usage/
  end
  
end