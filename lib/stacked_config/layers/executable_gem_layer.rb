module StackedConfig
  module Layers

    class ExecutableGemLayer < StackedConfig::Layers::GenericLayer


      def self.executable_gem_config_root
        return nil unless $PROGRAM_NAME

        Gem.loaded_specs.each_pair do |name, spec|
          executable_basename = File.basename($PROGRAM_NAME)
          return spec.full_gem_path if spec.executables.include? executable_basename
        end
        nil
      end

      def executable_gem_config_root
        self.class.executable_gem_config_root
      end

      def possible_sources
        [
            %w(##EXECUTABLE_GEM_CONFIG_ROOT## etc ##PROGRAM_NAME##.##EXTENSION##),
            %w(##EXECUTABLE_GEM_CONFIG_ROOT## etc ##PROGRAM_NAME## config.##EXTENSION##),
            %w(##EXECUTABLE_GEM_CONFIG_ROOT## etc ##PROGRAM_NAME## ##PROGRAM_NAME##.##EXTENSION##),
            %w(##EXECUTABLE_GEM_CONFIG_ROOT## config ##PROGRAM_NAME##.##EXTENSION##),
            %w(##EXECUTABLE_GEM_CONFIG_ROOT## config ##PROGRAM_NAME## config.##EXTENSION##),
            %w(##EXECUTABLE_GEM_CONFIG_ROOT## config ##PROGRAM_NAME## ##PROGRAM_NAME##.##EXTENSION##)
        ]
      end

      def perform_substitutions path_part
        return nil unless executable_gem_config_root
        res = path_part.dup
        res.gsub! '##EXECUTABLE_GEM_CONFIG_ROOT##', executable_gem_config_root
        exec_name = manager.nil? ? StackedConfig::Orchestrator.default_config_file_base_name : manager.config_file_base_name
        res.gsub! '##PROGRAM_NAME##', exec_name
        res
      end


    end

  end
end