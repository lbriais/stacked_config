require 'spec_helper'


describe StackedConfig::SourceHelper do

  subject {
    s = Object.new
    s.extend StackedConfig::SourceHelper
    s
  }

  it 'should provide an OS flavour' do
    expect(subject.os_flavour).to_not be_nil
  end

  it 'should provide a system config root' do
    expect(subject.system_config_root).to_not be_nil
  end


end

