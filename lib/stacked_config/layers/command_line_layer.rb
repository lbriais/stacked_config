module StackedConfig
  module Layers

    class CommandLineLayer < SuperStack::Layer

      attr_reader :slop_definition

      attr_accessor :extra_help

      def initialize
        @slop_definition = Slop.new
        build_command_line_options
      end

      def load(*args)
        slop_definition.parse
        slop_definition.banner = build_banner
        self.replace slop_definition.to_hash.delete_if {|k,v| v.nil?}
      end

      def possible_options
        slop_definition.to_hash.keys.sort
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

      def extra_parameters
        save = ARGV.dup
        return slop_definition.parse!.dup
      ensure
        ARGV.replace save
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
        if manager.nil?
          'No banner unless added to a manager !'
        else
          header = "\nUsage: #{manager.config_file_base_name} [options]\n#{manager.app_name} Version: #{manager.app_version}\n\n#{manager.app_description}"
          header += "\n#{extra_help}" unless extra_help.nil? or extra_help == ''
          header
        end
      end

    end

  end
end