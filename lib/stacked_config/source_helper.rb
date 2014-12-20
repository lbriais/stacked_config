module StackedConfig
  module SourceHelper

    attr_reader :config_file

    OS_FLAVOURS = {
        mingw32: :windows,
        linux: :unix
    }
    DEFAULT_OS_FLAVOUR = :unix

    SYSTEM_CONFIG_ROOT = {
        windows: [File.join(ENV['systemRoot'] || '', 'Config')],
        unix: '/etc'
    }

    EXTENSIONS = %w(conf CONF cfg CFG yml YML yaml YAML)

    def supported_oses
      OS_FLAVOURS.values.sort.uniq
    end

    def os_flavour
      @os_flavour ||= OS_FLAVOURS[RbConfig::CONFIG['target_os'].to_sym]
      @os_flavour ||= DEFAULT_OS_FLAVOUR
    end

    def system_config_root
      SYSTEM_CONFIG_ROOT[os_flavour]
    end

    def set_config_file(places)
      @file_name = nil
      places.each do |path_array|
        # Perform path substitutions
        potential_config_file = File.join path_array.map do |path_part|
          perform_substitutions path_part
        end
        # Try to find config file with extension
        EXTENSIONS.each do |extension|
          file  = potential_config_file.gsub '##EXTENSION##', extension
          if File.readable? file
            @file_name = file
            break
          end
        end
        break if @config_file
      end
      @file_name
    end



    def perform_substitutions path_part
      res = path_part
      res.gsub! '##SYSTEM_CONFIG_ROOT##', system_config_root
      res
    end


  end
end
