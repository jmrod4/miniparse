require 'spec_helper'



describe Miniparse do
  before :each do
    Miniparse.reset_default_controls
  end

  it 'has global controls' do
    expect( Miniparse.control :raise_on_unrecognized ).not_to be nil
    expect( Miniparse.control :rescue_argument_error ).not_to be nil
    expect( Miniparse.control :help_cmdline_empty ).not_to be nil
    expect( Miniparse.control :raise_global_args ).not_to be nil
    expect( Miniparse.control :formatted_help ).not_to be nil
    expect( Miniparse.control :width_display ).not_to be nil
    expect( Miniparse.control :width_indent ).not_to be nil
    expect( Miniparse.control :width_left ).not_to be nil
    expect( Miniparse.control :detailed_usage ).not_to be nil
    expect( Miniparse.control :autonegatable ).not_to be nil
    expect( Miniparse.control :autoshortable ).not_to be nil
  end
  
  it 'raises error if tries to get an unknown control' do
    expect { Miniparse.control(:some_unknown_control) 
        }.to raise_error KeyError
  end

  it 'can change controls' do
    Miniparse.set_control( { rescue_argument_error: false } )
    expect( Miniparse.control :rescue_argument_error ).to be false
    Miniparse.set_control( { rescue_argument_error: true } )
    expect( Miniparse.control :rescue_argument_error ).to be true
  end
  
  it 'raises error if tries to set an unknown control' do
    expect { Miniparse.set_control( { some_unknown_control: true } ) 
        }.to raise_error KeyError
  end
  
end
