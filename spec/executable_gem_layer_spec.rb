require 'spec_helper'


describe StackedConfig::Layers::ExecutableGemLayer do
  # subject is a modified ExecutableGemLayer to redirect executable_gem_config_root to the test directory
  subject {
    s = StackedConfig::Layers::ExecutableGemLayer.new
    gem_path = File.expand_path '../..', __FILE__
    allow(s).to receive(:executable_gem_config_root) {File.join(gem_path, 'test', 'tstgem') }
    s.rescan
    s
  }

  it 'should provide an executable gem config root' do
    expect(subject.executable_gem_config_root).to_not be_nil
  end

  it 'should return the path of the first matching config file it found' do
    expect(subject.file_name).not_to be_nil
  end


end