require 'spec_helper'


describe StackedConfig::Layers::UserLayer do

  # subject is a modified SystemLayer to redirect system_config_root to the test directory
  subject {
    s = StackedConfig::Layers::UserLayer.new
    os = s.os_flavour.to_s
    gem_path = File.expand_path '../..', __FILE__
    allow(s).to receive(:user_config_root) {File.join(gem_path, 'test', 'user') }
    s.rescan
    s
  }

  it 'should provide a user config root' do
    expect(subject.user_config_root).to_not be_nil
  end

  it 'should return the path of the first matching config file it found' do
    expect(subject.file_name).not_to be_nil
  end

  it 'should have an empty file_name if not present' do
    allow(File).to receive(:readable?) {false}
    subject.rescan
    expect(subject.file_name).to be_nil
  end

  it 'should enable to load the file' do
    expect(subject['an_array']).to be_nil
    subject.load
    expect(subject['an_array']).to be_an Array
  end



end
