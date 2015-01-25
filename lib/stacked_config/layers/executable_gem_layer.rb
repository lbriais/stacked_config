module StackedConfig
  module Layers

    class ExecutableGemLayer < StackedConfig::Layers::GenericLayer
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

    end

  end
end