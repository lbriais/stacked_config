module StackedConfig
  module Layers

    class SystemLayer < StackedConfig::Layers::GenericLayer

      SYSTEM_CONFIG_ROOT = {
          windows: [File.join(ENV['systemRoot'] || '', 'Config')],
          unix: '/etc'
      }

      def self.system_config_root
        SYSTEM_CONFIG_ROOT[os_flavour]
      end

      def system_config_root
        self.class.system_config_root
      end


      def possible_sources
        [
            ['##SYSTEM_CONFIG_ROOT##', 'stacked_config.##EXTENSION##' ],
            ['##SYSTEM_CONFIG_ROOT##', 'stacked_config', 'config.##EXTENSION##' ]
        ]
      end

      def perform_substitutions path_part
        res = path_part.dup
        res.gsub! '##SYSTEM_CONFIG_ROOT##', system_config_root
        res
      end


    end

  end
end
