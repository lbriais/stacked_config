module StackedConfig
  module Layers

    class CommandLineLayer < SuperStack::Layer

      attr_reader :slop_definition
      attr_accessor :executable_name, :app_name, :app_version, :app_description

      def initialize
        @slop_definition = Slop.new
        build_command_line_options
      end

      def load(*args)
        slop_definition.parse
        slop_definition.banner = build_banner
        clear
        merge! slop_definition.to_hash
      end

      def reload
        load
      end

      # Yields a slop definition to modify the command line parameters
      def add_command_line_section(title)
        raise 'Incorrect usage' unless block_given?
        slop_definition.separator build_separator(title)
        yield slop_definition
        reload
      end

      # @return [String] The formatted command line help
      def help
        slop_definition.to_s
      end

      private

      # Builds a nice separator
      def build_separator(title, width = 80, filler = '-')
        "#{filler * 2} #{title} ".ljust width, filler
      end

      # Builds common used command line options
      def build_command_line_options
        add_command_line_section('Generic options') do |slop|
          slop.on :auto, 'Auto mode. Bypasses questions to user.', :argument => false
          slop.on :simulate, 'Do not perform the actual underlying actions.', :argument => false
          slop.on :v, :verbose, 'Enable verbose mode.', :argument => false
          slop.on :h, :help, 'Displays this help.', :argument => false
        end
      end

      def build_banner
        "\nUsage: #{executable_name} [options]\n#{app_name} Version: #{app_version}\n\n#{app_description}"
      end



    end

  end
end