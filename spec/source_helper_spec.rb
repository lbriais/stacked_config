require 'spec_helper'


describe StackedConfig::SourceHelper do

  subject {StackedConfig::SourceHelper }

  it 'should provide an OS flavour' do
    expect(subject.os_flavour).to_not be_nil
    # s = Object.new
    # s.extend subject
    # expect(s.os_flavour).to_not be_nil
  end

  # it 'should provide a system config root' do
  #   expect(subject.system_config_root).to_not be_nil
  # end
  #
  # it 'should provide a user config root' do
  #   expect(subject.user_config_root).to_not be_nil
  # end
  #
  # it 'should provide an executable gem config root' do
  #   expect(subject.executable_gem_config_root).to_not be_nil
  # end
  #
  # it 'should provide a gem config root' do
  #   expect(subject.gem_config_root).to_not be_nil
  # end

end

