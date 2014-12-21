module StackedConfig
  module Layers

    class CommandLineLayer < SuperStack::Layer

      attr_reader :slop_definition, :executable_name, :app_name, :app_version, :app_description

      def initialize
        @slop_definition = Slop.new
        default_name = File.basename($PROGRAM_NAME)
        describes_application executable_name: default_name, app_name: default_name
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

      # sets the filename while maintaining the slop definition upto date
      # @param [String] filename
      def executable_name=(filename)
        @executable_name = filename
        reload
      end
      # sets the application name used for logging while maintaining the slop definition upto date
      # @param [String] fname
      def app_name=(name)
        @app_name = name
        reload
      end
      # sets the version while maintaining the slop definition upto date
      # @param [String] version
      def app_version=(version)
        @app_version = version
        reload
      end
      # sets the filename while maintaining the slop definition upto date
      # @param [String] description
      def app_description=(description)
        @app_description = description
        reload
      end

      # Yields a slop definition to modify the command line parameters
      # @param [String] title used to insert a slop separator
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

      # helper to add in one command any of the four base properties used
      # by the logger and the config objects.
      # @param [String] app_name
      # @param [String] script_filename
      # @param [String] app_version
      # @param [String] app_description
      def describes_application(options = {})
        app_name = options.fetch(:app_name, nil)
        executable_name = options.fetch(:executable_name, nil)
        app_version = options.fetch(:app_version, nil)
        app_description = options.fetch(:app_description, nil)
        @app_name ||= app_name unless app_name.nil?
        @app_version ||= app_version unless app_version.nil?
        @app_description = app_description unless app_description.nil?
        @executable_name = executable_name unless executable_name.nil?
        reload
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