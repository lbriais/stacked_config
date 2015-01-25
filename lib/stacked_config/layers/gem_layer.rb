module StackedConfig
  module Layers

    class GemLayer < StackedConfig::Layers::GenericLayer

      attr_reader :gem_name

      def gem_name=(gem_name)
        @gem_name = gem_name
        rescan
        reload
      end

      def possible_sources
        [
            %w(##GEM_CONFIG_ROOT## etc ##GEM_NAME##.##EXTENSION##),
            %w(##GEM_CONFIG_ROOT## etc ##GEM_NAME## config.##EXTENSION##),
            %w(##GEM_CONFIG_ROOT## etc ##GEM_NAME## ##GEM_NAME##.##EXTENSION##),
            %w(##GEM_CONFIG_ROOT## config ##GEM_NAME##.##EXTENSION##),
            %w(##GEM_CONFIG_ROOT## config ##GEM_NAME## config.##EXTENSION##),
            %w(##GEM_CONFIG_ROOT## config ##GEM_NAME## ##GEM_NAME##.##EXTENSION##)
        ]
      end

    end

  end
end