module StackedConfig
  module ProgramDescriptionHelper

    def add_command_line_section(title='Script specific', &block)
      command_line_layer.add_command_line_section title, &block
    end

    def executable_name
      command_line_layer.executable_name
    end
    def executable_name=(executable_name)
      return if executable_name.nil?
      command_line_layer.executable_name = executable_name
      rescan_layers
      reload_layers
    end

    def app_name
      command_line_layer.app_name
    end
    def app_name=(app_name)
      return if app_name.nil?
      command_line_layer.app_name = app_name
      command_line_layer.reload
    end

    def app_version
      command_line_layer.app_version
    end
    def app_version=(app_version)
      return if app_version.nil?
      command_line_layer.app_version = app_version
      command_line_layer.reload
    end

    def app_description
      command_line_layer.app_description
    end
    def app_description=(app_description)
      return if app_description.nil?
      command_line_layer.app_description = app_description
      command_line_layer.reload
    end

    def rescan_layers
      layers.values.each do |layer|
        if layer.respond_to? :rescan
          layer.clear
          layer.rescan
        end
      end

    end

    def describes_application(options = {})
      self.app_name = options.fetch(:app_name, nil)
      self.app_version = options.fetch(:app_version, nil)
      self.app_description = options.fetch(:app_description, nil)
      self.executable_name = options.fetch(:executable_name, nil)
    end

  end
end

