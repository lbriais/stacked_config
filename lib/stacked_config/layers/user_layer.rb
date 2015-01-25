module StackedConfig
  module Layers

    class UserLayer < StackedConfig::Layers::GenericLayer


      def self.user_config_root
        Dir.home
      end

      def user_config_root
        self.class.user_config_root
      end


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

      def perform_substitutions path_part
        res = path_part.dup
        res.gsub! '##USER_CONFIG_ROOT##', user_config_root

        exec_name = manager.nil? ? StackedConfig::Orchestrator.default_config_file_base_name : manager.config_file_base_name
        res.gsub! '##PROGRAM_NAME##', exec_name

        res
      end

    end

  end
end
