module StackedConfig
  module Layers

    class ExecutableGemLayer < StackedConfig::Layers::GenericLayer
      def possible_sources
        [
            %w(##GEM_CONFIG_ROOT## etc ##PROGRAM_NAME##.##EXTENSION##),
            %w(##GEM_CONFIG_ROOT## etc ##PROGRAM_NAME## config.##EXTENSION##),
            %w(##GEM_CONFIG_ROOT## etc ##PROGRAM_NAME## ##PROGRAM_NAME##.##EXTENSION##),
            %w(##GEM_CONFIG_ROOT## config ##PROGRAM_NAME##.##EXTENSION##),
            %w(##GEM_CONFIG_ROOT## config ##PROGRAM_NAME## config.##EXTENSION##),
            %w(##GEM_CONFIG_ROOT## config ##PROGRAM_NAME## ##PROGRAM_NAME##.##EXTENSION##)
        ]
      end

    end

  end
end