module StackedConfig
  class Orchestrator < SuperStack::Manager

    include StackedConfig::ProgramDescriptionHelper

    attr_reader :system_layer, :global_layer, :executable_gem_layer, :user_layer, :env_layer,
                :command_line_layer, :provided_config_file_layer

    def initialize
      super
      self.merge_policy = SuperStack::MergePolicies::FullMergePolicy
      setup_layers
      default_name = self.class.default_config_file_base_name
      describes_application config_file_base_name: default_name, app_name: default_name
    end


    def self.default_config_file_base_name
      File.basename($PROGRAM_NAME).gsub /\.[^\.]+$/, ''
    end

    def include_env_layer(filter = nil, priority = 60)
      @env_layer = StackedConfig::Layers::EnvLayer.new filter
      env_layer.name = 'Environment variables level'
      env_layer.priority = priority
      self << env_layer
    end

    private

    def setup_layers
      # The command line level.
      @command_line_layer = setup_layer StackedConfig::Layers::CommandLineLayer, 'Command line configuration level', 100

      # The system level
      @system_layer = setup_layer StackedConfig::Layers::SystemLayer, 'System-wide configuration level', 10

      # The executable gem level
      @executable_gem_layer = setup_layer StackedConfig::Layers::ExecutableGemLayer, 'Gem associated to the executable running configuration level', 20

      # The global level
      @global_layer = setup_layer StackedConfig::Layers::GlobalLayer, 'Global configuration level', 30

      # The user level
      @user_layer = setup_layer StackedConfig::Layers::UserLayer, 'User configuration level', 40

      # The specifically provided config file level
      @provided_config_file_layer = setup_layer StackedConfig::Layers::ProvidedConfigFileLayer, 'Specific config file configuration level', 50

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