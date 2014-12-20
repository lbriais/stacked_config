module StackedConfig
  module Layers

    class SystemLayer < SuperStack::Layer
      include StackedConfig::SourceHelper

      POSSIBLE_SOURCES = [
          ['##SYSTEM_CONFIG_ROOT##', 'stacked_config.##EXTENSION##' ],
          ['##SYSTEM_CONFIG_ROOT##', 'stacked_config', 'config.##EXTENSION##' ]
      ]

      def rescan
        set_config_file POSSIBLE_SOURCES
      end

      def initialize
        rescan
      end

    end

  end
end
