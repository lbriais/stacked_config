module StackedConfig
  module Layers

    class SystemLayer < StackedConfig::Layers::GenericLayer
      def possible_sources
        [
            ['##SYSTEM_CONFIG_ROOT##', 'stacked_config.##EXTENSION##' ],
            ['##SYSTEM_CONFIG_ROOT##', 'stacked_config', 'config.##EXTENSION##' ]
        ]
      end

    end

  end
end
