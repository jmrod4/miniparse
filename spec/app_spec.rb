require 'spec_helper'
require 'miniparse/app'



describe App do
  
  before :each do
    # default uses ARGV and that interferes with rspec
    App.configure_parser { |parser| parser.parse "" }
  end
  
  describe "public interface" do
    it 'has output class methods' do
      expect( App ).to respond_to :error
      expect( App ).to respond_to :warn
      expect( App ).to respond_to :info
      expect( App ).to respond_to :debug
    end
  
    it 'has class methods for the parser and its options' do
      expect( App ).to respond_to :parser
      expect( App ).to respond_to :options
    end
  
    it 'has class methods to configure the parser' do
      expect( App ).to respond_to :configure_parser
    end
  end
  
  describe "##parser" do
    it 'creates a new parser the first time is called' do
      expect( App.parser ).to be_a_kind_of(Miniparse::Parser)
    end  
    
    it 'the second and following times returns that same parser' do
      parser_1 = App.parser
      expect( App.parser ).to be parser_1
      expect( App.parser ).to be parser_1
    end
    
    it 'can reset the parser' do
      parser_1 = App.parser
      expect( App.parser ).to be parser_1
      App.reset_parser
      expect( App.parser ).not_to be parser_1
    end
    
  end
    
  describe "##configure_parser" do
    it "allows to configure the parser created by ##parser" do
      App.configure_parser do |parser|
        Miniparse.set_control(
            autoshortable: true,
            raise_global_args: true,
            )

        parser.add_option("--file FILENAME", "path to the todo file", 
            default: "todos.txt")
        parser.add_option("--create",  
            "creates a new todo file if it doesn't exists",
            negatable: true)

        parser.add_command(:done, "complete a task")
        parser.add_command(:list, "list tasks")

        parser.parse "--no-create --debug".split
      end
      expect( App.parser.inspect ).to include "create"
      expect( App.options[:debug] ).to be true
      expect( App.options[:create] ).to be false    
    end
  end
  
end
