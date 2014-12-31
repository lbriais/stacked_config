require 'spec_helper'


describe StackedConfig::Layers::GemLayer do
  # subject is a modified SystemLayer to redirect gem_config_root to the test directory
  subject {
    s = StackedConfig::Layers::GemLayer.new
    gem_path = File.expand_path '../..', __FILE__
    allow(s).to receive(:gem_config_root) {File.join(gem_path, 'test', 'tstgem') }
    s.rescan
    s
  }

  it 'should return the path of the first matching config file it found' do
    expect(subject.file_name).not_to be_nil
  end


end