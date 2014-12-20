module StackedConfig
  module Layers

    class GlobalLayer < StackedConfig::Layers::GenericLayer
      def possible_sources
        [
            ['##SYSTEM_CONFIG_ROOT##', '##PROGRAM_NAME##.##EXTENSION##' ],
            ['##SYSTEM_CONFIG_ROOT##', '##PROGRAM_NAME##', 'config.##EXTENSION##' ],
            ['##SYSTEM_CONFIG_ROOT##', '##PROGRAM_NAME##', '##PROGRAM_NAME##.##EXTENSION##' ]
        ]
      end

    end

  end
end
