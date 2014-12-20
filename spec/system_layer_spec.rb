require 'spec_helper'


describe StackedConfig::Layers::SystemLayer do
  subject {
    s = Object.new
    s.extend StackedConfig::SourceHelper
    real_root_path = s.system_config_root
    os = s.os_flavour.to_s
    gem_path = File.expand_path '../..', __FILE__
    allow(s).to receive(:system_config_root) {File.join(gem_path, 'test', os, real_root_path) }
    s
  }
end
