module StackedConfig
  module SourceHelper

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

    def self.os_flavour
      OS_FLAVOURS[RbConfig::CONFIG['target_os'].to_sym] || DEFAULT_OS_FLAVOUR
    end

    def self.supported_oses
      OS_FLAVOURS.values.sort.uniq
    end

    def self.system_config_root
      SYSTEM_CONFIG_ROOT[os_flavour]
    end

    def system_config_root
      StackedConfig::SourceHelper.system_config_root
    end


    def self.user_config_root
      Dir.home
    end

    def user_config_root
      StackedConfig::SourceHelper.user_config_root
    end


    def self.executable_gem_config_root
      return nil unless $PROGRAM_NAME

      Gem.loaded_specs.each_pair do |name, spec|
        executable_basename = File.basename($PROGRAM_NAME)
        return spec.full_gem_path if spec.executables.include? executable_basename
      end
      nil
    end

    def executable_gem_config_root
      StackedConfig::SourceHelper.executable_gem_config_root
    end


    def self.gem_config_root(gem_name)
      return nil unless gem_name
      Gem.loaded_specs.each_pair do |name, spec|
        return spec.full_gem_path if name == gem_name
      end
      nil
    end

    def gem_config_root
     self.respond_to?(:gem_name) ? StackedConfig::SourceHelper.gem_config_root(gem_name) : nil
    end


    def supported_oses
      StackedConfig::SourceHelper.supported_oses
    end

    def os_flavour
      @os_flavour ||= StackedConfig::SourceHelper.os_flavour
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



    def perform_substitutions path_part
      res = path_part.dup
      res.gsub! '##SYSTEM_CONFIG_ROOT##', system_config_root
      res.gsub! '##USER_CONFIG_ROOT##', user_config_root

      exec_name = manager.nil? ? StackedConfig::Orchestrator.default_config_file_base_name : manager.config_file_base_name
      res.gsub! '##PROGRAM_NAME##', exec_name

      if res =~ /##EXECUTABLE_GEM_CONFIG_ROOT##/
        return nil unless executable_gem_config_root
        res.gsub! '##EXECUTABLE_GEM_CONFIG_ROOT##', executable_gem_config_root
      end

      if res =~ /##GEM_CONFIG_ROOT##/
        return nil unless gem_config_root
        res.gsub! '##GEM_CONFIG_ROOT##', gem_config_root
      end

      res.gsub! '##GEM_NAME##', gem_name if self.respond_to? :gem_name

      res
    end


  end
end
