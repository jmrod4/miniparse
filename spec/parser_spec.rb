require 'spec_helper'

# FIXME add more examples



describe Miniparse::Parser do

  before :each do
    Miniparse.reset_controls
    expect(@parser = Miniparse::Parser.new).not_to be nil
  end

  it 'has a public interface' do
    expect(@parser).to respond_to :args
    expect(@parser).to respond_to :options
    expect(@parser).to respond_to :command_name
    expect(@parser).to respond_to :command_args
    expect(@parser).to respond_to :command_options
    expect(@parser).to respond_to :current_command_name
    expect(@parser).to respond_to :add_option
    expect(@parser).to respond_to :add_command
    expect(@parser).to respond_to :parse
    expect(@parser).to respond_to :help_desc
    expect(@parser).to respond_to :help_usage
  end
  
  describe "#add_option" do
    
    it 'option needs a specification and a description' do
      expect { @parser.add_option() 
        }.to raise_error ArgumentError
      expect { @parser.add_option("--debug") 
        }.to raise_error ArgumentError
      expect(  @parser.add_option("--debug", "crush bugs" ) 
        ).not_to be nil
    end
    
    it 'but a description can be nil' do
      expect(  @parser.add_option("--debug", nil) 
        ).not_to be nil
    end
    
    it 'can add switch options' do
      expect(@parser.add_option("--debug", nil)
        ).not_to be nil
    end

    it 'can add flag options' do
      expect(@parser.add_option("--verbose LEVEL", nil)
        ).not_to be nil
      expect(@parser.add_option("--debug=LEVEL", nil)
        ).not_to be nil
    end

    it 'can add options with blocks' do
      expect(@parser.add_option("--debug", nil) { |value| puts value }
        ).not_to be nil
    end

    it 'options can have a default' do
      expect(@parser.add_option("--debug", nil, default: false)
        ).not_to be nil
      expect(@parser.add_option("--verbose=LEVEL", nil, default: "1")
        ).not_to be nil
    end
    
    it 'options can be shortable' do
      expect(@parser.add_option("--debug", nil, shortable: true)
        ).not_to be nil
      expect(@parser.add_option("--verbose LEVEL", nil, shortable: true)
        ).not_to be nil
    end
    
    it 'raises an error if added ambiguous (conflicting) shortable options' do
      expect(@parser.add_option("--debug", nil, shortable: true)
        ).not_to be nil
      expect { @parser.add_option("--draw", nil, shortable: true)
        }.to raise_error SyntaxError
    end

    it 'switch options can be negatable' do
      expect(@parser.add_option("--debug", nil, negatable: true)
        ).not_to be nil
    end
    
  end  
  
  describe "#add_command" do

    it 'needs a name and a description' do
      expect { @parser.add_command() 
        }.to raise_error ArgumentError
      expect { @parser.add_command("kill") 
        }.to raise_error ArgumentError
      expect(  @parser.add_command("kill", "crush tasks" ) 
        ).not_to be nil
    end

    it 'but a description can be nil' do
      expect(  @parser.add_command("kill", nil) 
        ).not_to be nil
    end

    it 'name can be a symbol or a string' do
      expect(  @parser.add_command(:kill, nil) 
        ).not_to be nil
      expect(  @parser.add_command("save", nil) 
        ).not_to be nil
    end
    
    it 'can add commands with blocks' do
      expect(@parser.add_command(:kill, nil) { |args| puts args }
        ).not_to be nil
    end
    
  end 
  
  describe "#help_usage" do
    it 'knows msg for help on usage including options but no commands' do
      Miniparse.set_control(detailed_usage: true)
      @parser.add_option("--sort", "order please")
      @parser.add_command("list", "many lines")
      help = @parser.help_usage
      expect(help).to match /usage.+sort/m
      expect(help).not_to match /list/m
    end
  end
  
  describe "#help_desc" do
  
    it 'knows msg for descriptive help' do
      @parser.add_option("--sort", "order please")
      @parser.add_command("debug", "crush bugs")
      help = @parser.help_desc
      expect(help).to match /--sort.+order.+please/m
      expect(help).to match /debug.+crush.+bugs/m
    end
  
    it "if option description is nil then option doesn't appear in the descriptive help" do
      @parser.add_option("--debug", nil)
      @parser.add_option("--sort", "order please")
      help = @parser.help_desc
      expect(help).not_to match /debug/m
      expect(help).to match /sort.+please/m
    end

    it "if command description is nil then it has just its name in the 'More commands' list" do
      @parser.add_command("list", nil)
      @parser.add_command("debug", "crush bugs")
      help = @parser.help_desc
      expect(help).to match /More commands.+list/m
      expect(help).not_to match /More commands.+debug/m
      expect(help).to match /debug.+crush/m
    end
    
  end
 
  context "with multiple options and commands, no defaults" do
    before :each do
      @parser.add_option "--hide", nil,
        shortable: true, negatable: false
      @parser.add_option "--debug", "find the bugs", 
        shortable: false, negatable: false
      @parser.add_option "--verbose", "talk to much", 
        shortable: true, negatable: true
      @parser.add_option "--read FILE", "where to read",
        shortable: true      
      
      expect(@parser.current_command_name).to be nil

      @parser.add_command :list, "output many lines"  
      @parser.add_option "--sort", "in an ordered way" 
      expect(@parser.current_command_name).to be :list

      @parser.add_command "kill", nil
      expect(@parser.current_command_name).to be :kill
   
      expect(@parser.options).to eq({})
      expect(@parser.command_name).to be nil
      expect(@parser.command_args).to be nil
      expect(@parser.command_options).to be nil
    end

    describe "#parse" do    
      it "can parse switch options" do
        expect(@parser.parse(%w(--hide --debug --verbose))).to eq []
        expect(@parser.options[:hide]).to be true
        expect(@parser.options[:debug]).to be true
        expect(@parser.options[:verbose]).to be true
      end
      
      it "can parse negated switch options" do
        expect(@parser.parse(%w(--no-verbose))).to eq []
        expect(@parser.options[:verbose]).to be false
      end
      
      it "can parse shorted switch options" do
        expect(@parser.parse(%w(-h -v))).to eq []
        expect(@parser.options[:hide]).to be true
        expect(@parser.options[:verbose]).to be true
      end

      it "can parse grouped shorted switch options" do
        pending "NEW FEATURE"
        expect { @parser.parse(%w(-hv)) }.not_to raise_error
        expect(@parser.options[:hide]).to be true
        expect(@parser.options[:verbose]).to be true
      end
      
      it "can parse flag options" do
        expect(@parser.parse(%w(--read otherfile.txt))).to eq []
        expect(@parser.options[:read]).to eq "otherfile.txt"
      end

      it "can parse shorted flag options" do
        expect(@parser.parse(%w(-r otherfile.txt))).to eq []
        expect(@parser.options[:read]).to eq "otherfile.txt"
      end
      
      it "can parse commands" do
        expect(@parser.parse(%w(list))).to eq []
        expect(@parser.command_name).to be :list
        expect(@parser.command_args).to eq []
        expect(@parser.command_options).to eq({})
      end

      it "can parse commands with arguments" do
        expect(@parser.parse(%w(kill something))).to eq []
        expect(@parser.command_name).to be :kill
        expect(@parser.command_args).to eq ["something"]
        expect(@parser.command_options).to eq({})
      end

      it "can parse commands with options" do
        expect(@parser.parse(%w(list --sort))).to eq []
        expect(@parser.command_name).to be :list
        expect(@parser.command_args).to eq []
        expect(@parser.command_options[:sort]).to be true
      end
      
      it "can parse only one command at a time" do
        expect(@parser.parse(%w(list kill))).to eq []
        expect(@parser.command_name).to be :list
        expect(@parser.command_args).to eq ["kill"]
      end

      it "executes the blocks added to options" do
        parser = Miniparse::Parser.new
        result = nil
        parser.add_option("--active", nil, negatable: true) do |value| 
          result = value 
        end
        expect(result).to be nil
        expect(parser.parse(%w(--active))).to eq []
        expect(result).to be true
        expect(parser.parse(%w(--no-active))).to eq []
        expect(result).to be false
      end
      
      it "executes the blocks added to commands" do
        result = nil
        @parser.add_command(:active, nil) do |args| 
          result = args
        end
        expect(result).to be nil
        expect(@parser.parse(%w(active a b))).to eq []
        expect(result).to eq %w(a b)
        expect(@parser.parse(%w(active))).to eq []
        expect(result).to eq []
      end
      
    end

  end
  
  context "with default values" do 
    before :each do
      @parser.add_option "--read FILE", "where to read",
        default: "myfile.txt"
      @parser.add_option "--debug", nil,
        default: false, negatable: true
      @parser.add_option "--normal", nil,
        default: true, negatable: true

      expect(@parser.current_command_name).to be nil
      # TODO consider if it is correct that options won't reflect the defaults until parsed
      expect(@parser.options).to eq({})
      expect(@parser.command_name).to be nil
      expect(@parser.command_args).to be nil
      expect(@parser.command_options).to be nil
    end

    describe '#parse' do
      
      it "won't change values from default if the option is not specifed" do
        expect(@parser.parse(%w(other))).to eq ["other"]      
        expect(@parser.options[:read]).to eq "myfile.txt"
        expect(@parser.options[:debug]).to be false
      end
      
      it "will change values from default to the specified value if the option is specifed" do
        expect(@parser.parse(%w(--debug --read otherfile.txt))).to eq []      
        expect(@parser.options[:read]).to eq "otherfile.txt"
        expect(@parser.options[:debug]).to be true
      end
      
      it "a switch option will always parse to true, no matter the default value" do
        expect(@parser.parse(%w(--normal --debug))).to eq []      
        expect(@parser.options[:normal]).to be true
        expect(@parser.options[:debug]).to be true
      end

      it "a negated switch option will always parse to false, no matter the default value" do
        expect(@parser.parse(%w(--no-normal --no-debug))).to eq []      
        expect(@parser.options[:normal]).to be false
        expect(@parser.options[:debug]).to be false
      end
      
    end
    
  end


end