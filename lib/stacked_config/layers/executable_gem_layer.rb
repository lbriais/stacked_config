module StackedConfig
  module Layers

    class ExecutableGemLayer < StackedConfig::Layers::GenericLayer
      def possible_sources
        [
            ['##GEM_CONFIG_ROOT##', 'etc', '##PROGRAM_NAME##.##EXTENSION##' ],
            ['##GEM_CONFIG_ROOT##', 'etc', '##PROGRAM_NAME##', 'config.##EXTENSION##' ],
            ['##GEM_CONFIG_ROOT##', 'etc', '##PROGRAM_NAME##', '##PROGRAM_NAME##.##EXTENSION##' ],
            ['##GEM_CONFIG_ROOT##', 'config', '##PROGRAM_NAME##.##EXTENSION##' ],
            ['##GEM_CONFIG_ROOT##', 'config', '##PROGRAM_NAME##', 'config.##EXTENSION##' ],
            ['##GEM_CONFIG_ROOT##', 'config', '##PROGRAM_NAME##', '##PROGRAM_NAME##.##EXTENSION##' ]
        ]
      end

    end

  end
end