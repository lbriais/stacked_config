module StackedConfig
  module Layers

    class CommandLineLayer < SuperStack::Layer

      attr_reader :slop_definition

      def initialize
        @file_name = 'None'
        @slop_definition = Slop.new
        add_command_line_section do |slop|
          slop.on :u, :useless, 'Stupid option', :argument => false
          slop.on :anint, 'Stupid option with integer argument', :argument => true, :as => Integer
        end
      end

      def load(*args)
        slop_definition.parse
        clear
        merge! slop_definition.to_hash
      end

      # Yields a slop definition to modify the command line parameters
      # @param [String] title used to insert a slop separator
      def add_command_line_section(title='Script specific')
        raise 'Incorrect usage' unless block_given?
        slop_definition.separator build_separator(title)
        yield slop_definition
      end

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
        "\nUsage: #{script_filename} [options]\n#{app_name} Version: #{app_version}\n\n#{app_description}"
      end



    end

  end
end