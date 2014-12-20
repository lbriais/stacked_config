module StackedConfig
  module Layers

    class UserLayer < StackedConfig::Layers::GenericLayer

      def possible_sources
        [
            ['##USER_CONFIG_ROOT##', '.##PROGRAM_NAME##.##EXTENSION##' ],
            ['##USER_CONFIG_ROOT##', '.config', '##PROGRAM_NAME##.##EXTENSION##' ],
            ['##USER_CONFIG_ROOT##', '.config', '##PROGRAM_NAME##', 'config.##EXTENSION##' ],
            ['##USER_CONFIG_ROOT##', '.config', '##PROGRAM_NAME##', '##PROGRAM_NAME##.##EXTENSION##' ],
            ['##USER_CONFIG_ROOT##', '.##PROGRAM_NAME##', 'config.##EXTENSION##' ],
            ['##USER_CONFIG_ROOT##', '.##PROGRAM_NAME##', '##PROGRAM_NAME##.##EXTENSION##' ]
        ]
      end

    end

  end
end
