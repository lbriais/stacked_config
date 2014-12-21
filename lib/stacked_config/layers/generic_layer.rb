module StackedConfig
  module Layers

    class GenericLayer < SuperStack::Layer

      include StackedConfig::SourceHelper

      attr_reader :orchestrator

      def rescan

        set_config_file possible_sources
      end

      def initialize
        rescan
      end

    end

  end
end