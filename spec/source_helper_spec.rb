require 'spec_helper'


describe StackedConfig::SourceHelper do

  subject {
    s = Object.new
    s.extend StackedConfig::SourceHelper
    real_root_path = s.system_config_root
    os = s.os_flavour.to_s
    gem_path = File.expand_path '../..', __FILE__
    allow(s).to receive(:system_config_root) {File.join(gem_path, 'test', os, real_root_path) }
    s
  }

  it 'should provide a system config root' do
    s = Object.new
    s.extend StackedConfig::SourceHelper
    expect(s.system_config_root).to_not be_nil
  end




end

