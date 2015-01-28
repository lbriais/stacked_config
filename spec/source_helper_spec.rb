require 'spec_helper'


describe StackedConfig::SourceHelper do

  subject {StackedConfig::SourceHelper }

  it 'should provide an OS flavour' do
    expect(subject.os_flavour).to_not be_nil
    # s = Object.new
    # s.extend subject
    # expect(s.os_flavour).to_not be_nil
  end

end

