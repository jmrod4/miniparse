require 'spec_helper'

describe Miniparse::Parser do

  before :each do
    @parser = Miniparse::Parser.new
  end

  it 'has a public interface' do
    expect(@parser.respond_to?(:args)).to be_truthy
    expect(@parser.respond_to?(:options)).to be_truthy
    expect(@parser.respond_to?(:current_command)).to be_truthy
    expect(@parser.respond_to?(:command_args)).to be_truthy
    expect(@parser.respond_to?(:command_options)).to be_truthy
    expect(@parser.respond_to?(:parsed_command)).to be_truthy
    expect(@parser.respond_to?(:command_options)).to be_truthy
    expect(@parser.respond_to?(:add_option)).to be_truthy
    expect(@parser.respond_to?(:add_command)).to be_truthy
    expect(@parser.respond_to?(:parse)).to be_truthy
    expect(@parser.respond_to?(:help_desc)).to be_truthy
    expect(@parser.respond_to?(:help_usage)).to be_truthy
  end

  # FIXME add more concrete examples
end