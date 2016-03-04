require 'spec_helper'

describe Miniparse::Commander do

  before :each do
    @cmdr = Miniparse::Commander.new
  end

  it 'has a public interface' do
    expect(@cmdr.respond_to?(:current_command)).to be_truthy
    expect(@cmdr.respond_to?(:parsed_command)).to be_truthy
    expect(@cmdr.respond_to?(:parsed_args)).to be_truthy
    expect(@cmdr.respond_to?(:parsed_values)).to be_truthy
    expect(@cmdr.respond_to?(:current_broker)).to be_truthy
    expect(@cmdr.respond_to?(:add_command)).to be_truthy
    expect(@cmdr.respond_to?(:split_argv)).to be_truthy
    expect(@cmdr.respond_to?(:parse_argv)).to be_truthy
    expect(@cmdr.respond_to?(:help_desc)).to be_truthy
  end

  # FIXME add more concrete examples

end