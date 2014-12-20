module StackedConfig
  class Orchestrator < SuperStack::Manager

    attr_reader :system_layer

    def initialize
      super
      self.merge_policy = SuperStack::MergePolicies::FullMergePolicy
      setup_layers
    end


    private

    def setup_layers
      # The system level
      @system_layer = setup_layer StackedConfig::Layers::SystemLayer, 'System-wide configuration level', 10
      system_layer.load

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