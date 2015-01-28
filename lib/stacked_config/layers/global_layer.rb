module StackedConfig
  module Layers

    class GlobalLayer < StackedConfig::Layers::SystemLayer
      def possible_sources
        [
            ['##SYSTEM_CONFIG_ROOT##', '##PROGRAM_NAME##.##EXTENSION##' ],
            ['##SYSTEM_CONFIG_ROOT##', '##PROGRAM_NAME##', 'config.##EXTENSION##' ],
            ['##SYSTEM_CONFIG_ROOT##', '##PROGRAM_NAME##', '##PROGRAM_NAME##.##EXTENSION##' ]
        ]
      end

      def perform_substitutions(path_part)
        res = path_part.dup
        res.gsub! '##SYSTEM_CONFIG_ROOT##', system_config_root

        exec_name = manager.nil? ? StackedConfig::Orchestrator.default_config_file_base_name : manager.config_file_base_name
        res.gsub! '##PROGRAM_NAME##', exec_name

        res
      end

    end



  end
end
