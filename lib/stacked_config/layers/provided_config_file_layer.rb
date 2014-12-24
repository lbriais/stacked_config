module StackedConfig
  module Layers

    class ProvidedConfigFileLayer < SuperStack::Layer


      def managed
        build_command_line_options unless @already_built
        if manager[:'config-file']
          if File.readable? manager[:'config-file']
            @file_name = manager[:'config-file']
            self.merge_policy = SuperStack::MergePolicies::OverridePolicy if manager[:'config-override']
          end
        end
      end

      private

      def build_command_line_options
        manager.add_command_line_section('Configuration options') do |slop|
          slop.on 'config-file', 'Specify a config file.', :argument => true
          slop.on 'config-override', 'If specified override all other config.', :argument => false
        end
        @already_built = true
      end


    end

  end
end
