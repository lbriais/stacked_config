require 'spec_helper'


describe StackedConfig::Layers::GemLayer do
  # subject is a modified GemLayer to redirect gem_config_root to the test directory
  subject {
    s = StackedConfig::Layers::GemLayer.new
    gem_path = File.expand_path '../..', __FILE__
    allow(s).to receive(:gem_config_root) {File.join(gem_path, 'test', 'tstgem') }
    s.gem_name = 'tstgem'
    s
  }

  it 'should provide a gem config root' do
    expect(subject.gem_config_root).to_not be_nil
  end

  it 'should return the path of the first matching config file it found' do
    expect(subject.file_name).not_to be_nil
  end


end