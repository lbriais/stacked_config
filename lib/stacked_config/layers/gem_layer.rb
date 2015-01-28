module StackedConfig
  module Layers

    class GemLayer < StackedConfig::Layers::GenericLayer

      attr_reader :gem_name

      def self.gem_config_root(gem_name)
        return nil unless gem_name
        Gem.loaded_specs.each_pair do |name, spec|
          return spec.full_gem_path if name == gem_name
        end
        nil
      end

      def gem_config_root
        self.class.gem_config_root gem_name
      end


      def gem_name=(gem_name)
        @gem_name = gem_name.to_s
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

      def perform_substitutions path_part
        return nil unless gem_config_root
        res = path_part.dup
        res.gsub! '##GEM_CONFIG_ROOT##', gem_config_root
        res.gsub! '##GEM_NAME##', gem_name if self.respond_to? :gem_name
        res
      end


    end

  end
end