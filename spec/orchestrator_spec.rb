require 'spec_helper'


describe StackedConfig::Orchestrator do

  subject {
    # Patching SourceHelper to find test config files in this gem test directory instead of from the system.
    os = StackedConfig::SourceHelper.os_flavour
    gem_path = File.expand_path '../..', __FILE__
    altered_sys_conf_root = File.join gem_path, 'test', os.to_s, StackedConfig::SourceHelper::SYSTEM_CONFIG_ROOT[os]
    altered_user_conf_root = File.join gem_path, 'test', 'user'
    altered_gem_conf_root = File.join(gem_path, 'test', 'tstgem')

    allow(StackedConfig::SourceHelper).to receive(:system_config_root) { altered_sys_conf_root }
    allow(StackedConfig::SourceHelper).to receive(:user_config_root) { altered_user_conf_root }
    allow(StackedConfig::SourceHelper).to receive(:gem_config_root) { altered_gem_conf_root }

    StackedConfig::Orchestrator.new
  }

  it 'should have multiple layers' do
    expect(subject.layers.length > 0).to be_truthy
    # puts '#' * 80
    # puts subject.detailed_layers_info
    # puts '#' * 80
    # puts subject[].to_yaml
    # puts '#' * 80
    # puts subject.command_line_layer.help
  end


  context 'when changing the executable_name' do

    it 'should reload all config files' do
      expect(subject[:user_property]).not_to be_nil
      expect(subject[:weird_property]).to be_nil
      subject.executable_name = 'weird_name'
      expect(subject[:user_property]).to be_nil
      expect(subject[:weird_property]).not_to be_nil
    end

    it 'should keep the modified values' do
      subject[:modified_value] = :pipo
      subject.executable_name = 'weird_name'
      expect(subject[:modified_value]).not_to be_nil
    end

  end

  context 'when setup by default, priorities should be defined in the Unix standard way' do

    it 'should have the system layer evaluated first' do
      expect(subject.system_layer).to be subject.to_a.first
    end

    it 'should have the gem layer evaluated in second' do
      expect(subject.gem_layer).to be subject.to_a[1]
    end

    it 'should have the global layer evaluated in third' do
      expect(subject.global_layer).to be subject.to_a[2]
    end

    it 'should have the user layer evaluated in fourth' do
      expect(subject.user_layer).to be subject.to_a[3]
    end

    it 'should have the specific-file layer evaluated in fifth' do
      expect(subject.provided_config_file_layer).to be subject.to_a[4]
    end

    it 'should have the command-line layer evaluated in sixth' do
      expect(subject.command_line_layer).to be subject.to_a[5]
    end

    it 'should have the writable layer evaluated last' do
      expect(subject.write_layer).to be subject.to_a.last
    end

  end

  context 'when config-file is provided on the command line' do

    let(:test_config_file) {
      gem_path = File.expand_path '../..', __FILE__
      File.join gem_path, 'test', 'specific.yml'
    }

    it 'should add the content of the specified config-file' do
      subject[:'config-file'] = test_config_file
      subject.provided_config_file_layer.managed
      subject.provided_config_file_layer.reload
      expect(subject[:system_property]).not_to be_nil
      expect(subject[:global_property]).not_to be_nil
      expect(subject[:user_property]).not_to be_nil
      expect(subject[:specific_property]).not_to be_nil
    end


    context 'when specifying config-override on the command line' do

      it 'should override all preceding layers (system, global, user)' do
        subject[:'config-file'] = test_config_file
        subject[:'config-override'] = true
        subject.provided_config_file_layer.managed
        subject.provided_config_file_layer.reload
        expect(subject[:system_property]).to be_nil
        expect(subject[:global_property]).to be_nil
        expect(subject[:user_property]).to be_nil
        expect(subject[:specific_property]).not_to be_nil
        expect(subject[:'config-override']).not_to be_nil
      end


    end

  end


end