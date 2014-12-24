module StackedConfig
  class Orchestrator < SuperStack::Manager

    include StackedConfig::ProgramDescriptionHelper

    attr_reader :system_layer, :global_layer, :user_layer, :command_line_layer,
                :provided_config_file_layer

    def initialize
      super
      self.merge_policy = SuperStack::MergePolicies::FullMergePolicy
      setup_layers
      default_name = self.class.default_executable_name
      describes_application executable_name: default_name, app_name: default_name
    end

    def detailed_layers_info
      info, sep = [], '-' * 80
      info << sep
      layers.values.sort {|a, b| a.priority <=> b.priority}.each do |layer|
        info << layer.name
        if layer.file_name.nil?
          info << 'There is no file attached to this level.'
        else
          info << "Using '#{layer.file_name}' as config file for this layer."
        end
        if layer.empty?
          info << 'There is no data in this layer'
        else
          info << 'This layer contains the following data:'
          info << layer.to_yaml
        end
        info << sep
      end
      info.join "\n"
    end

    def command_line_help
      command_line_layer.help
    end

    def self.default_executable_name
      File.basename($PROGRAM_NAME).gsub /\.[^\.]+$/, ''
    end

    private

    def setup_layers
      # The command line level.
      @command_line_layer = setup_layer StackedConfig::Layers::CommandLineLayer, 'Command line configuration level', 100

      # The system level
      @system_layer = setup_layer StackedConfig::Layers::SystemLayer, 'System-wide configuration level', 10

      # The global level
      @global_layer = setup_layer StackedConfig::Layers::GlobalLayer, 'Global configuration level', 20

      # The user level
      @user_layer = setup_layer StackedConfig::Layers::UserLayer, 'User configuration level', 30

      # The specifically provided config file level
      @provided_config_file_layer = setup_layer StackedConfig::Layers::ProvidedConfigFileLayer, 'Specific config file configuration level', 40

      # The layer to write something
      override_layer = setup_layer SuperStack::Layer, 'Overridden configuration level', 1000
      self.write_layer = override_layer

      reload_layers
    end

    def setup_layer(class_type, name, priority)
      layer = class_type.new
      layer.name = name
      layer.priority = priority
      self << layer
      layer
    end
    
    
  end
end