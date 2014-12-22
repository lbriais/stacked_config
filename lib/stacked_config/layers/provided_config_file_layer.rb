module StackedConfig
  module Layers

    class ProvidedConfigFileLayer < SuperStack::Layer


      def initialize
        build_command_line_options
      end

      private

      def build_command_line_options
        add_command_line_section('Configuration options') do |slop|
          slop.on 'config-file', 'Specify a config file.', :argument => true
          slop.on 'config-override', 'If specified override all other config.', :argument => false
        end
      end


    end

  end
end
