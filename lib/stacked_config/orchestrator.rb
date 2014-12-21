module StackedConfig
  class Orchestrator < SuperStack::Manager

    attr_reader :system_layer, :global_layer, :user_layer, :command_line_layer

    def initialize
      super
      self.merge_policy = SuperStack::MergePolicies::FullMergePolicy
      setup_layers
    end


    # Yields a slop definition to modify the command line parameters
    # @param [String] title used to insert a slop separator
    def add_command_line_section(title='Script specific', &block)
      command_line_layer.add_command_line_section title, &block
    end

    private

    def setup_layers
      # The system level
      @system_layer = setup_layer StackedConfig::Layers::SystemLayer, 'System-wide configuration level', 10

      # The global level
      @global_layer = setup_layer StackedConfig::Layers::GlobalLayer, 'Global configuration level', 20

      # The user level
      @user_layer = setup_layer StackedConfig::Layers::UserLayer, 'User configuration level', 30

      # The command line level
      @command_line_layer = setup_layer StackedConfig::Layers::CommandLineLayer, 'Command line configuration level', 100

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