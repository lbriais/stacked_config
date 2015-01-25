module StackedConfig
  module SourceHelper

    OS_FLAVOURS = {
        mingw32: :windows,
        linux: :unix
    }
    DEFAULT_OS_FLAVOUR = :unix


    EXTENSIONS = %w(conf CONF cfg CFG yml YML yaml YAML)

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def os_flavour
        StackedConfig::SourceHelper.os_flavour
      end

      def supported_oses
        StackedConfig::SourceHelper.supported_oses
      end
    end

    def self.os_flavour
      OS_FLAVOURS[RbConfig::CONFIG['target_os'].to_sym] || DEFAULT_OS_FLAVOUR
    end

    def self.supported_oses
      OS_FLAVOURS.values.sort.uniq
    end

    def os_flavour
      @os_flavour ||= self.class.os_flavour
    end

    def supported_oses
      self.class.supported_oses
    end

    def set_config_file(places)
      @file_name = nil
      places.each do |path_array|
        # Perform path substitutions
        begin
          potential_config_file = File.join(path_array.map { |path_part| perform_substitutions path_part })
        rescue
          #do nothing
        end
        return unless potential_config_file
        # Try to find config file with extension
        EXTENSIONS.each do |extension|
          file  = potential_config_file.gsub '##EXTENSION##', extension
          if File.readable? file
            @file_name = file
            return @file_name
          end
        end
      end
    end

  end
end
