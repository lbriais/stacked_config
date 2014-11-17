module StackedConfig
  module SourceManager

    OS_FLAVOURS = {
        mingw32: :windows,
        linux: :unix
    }
    DEFAULT_OS_FLAVOUR = :unix
    OS_DEPENDING_PLACES = {
        unix: {
            system: ['/etc'],

            # Where could be stored global wide configuration
            global: %w(/etc /usr/local/etc),

            # Where could be stored user configuration
            user:  [File.join(ENV['HOME'] || '', '.config')]
        },
        windows: {
            system: [File.join(ENV['systemRoot'] || '', 'Config')],

            # Where could be stored global configuration
            global: [File.join(ENV['systemRoot']|| '', 'Config'),
                     File.join(ENV['ALLUSERSPROFILE']|| '', '/Application Data')],

            # Where could be stored user configuration
            user: [ENV['APPDATA']]
        }
    }

    def supported_oses
      OS_FLAVOURS.values.sort.uniq
    end

    def supported_levels
      config_file_places.keys
    end

    def os_flavour
      @os_flavour ||= OS_FLAVOURS[RbConfig::CONFIG['target_os'].to_sym]
      @os_flavour ||= DEFAULT_OS_FLAVOUR
    end

    def config_file_places(level=:all, os_flavour = self.os_flavour)
      places = level == :all ? OS_DEPENDING_PLACES[os_flavour] : OS_DEPENDING_PLACES[os_flavour][level]
      places
    end

    def spec_of_file(file=__FILE__)
      Gem::Specification.find do |spec|
        File.fnmatch(File.join(spec.full_gem_path,'*'), file)
      end
    end

    private


    def self.gem_root_path(file=__FILE__)
      file=__FILE__ if file.nil?
      searcher = if Gem::Specification.respond_to? :find
                   # ruby 2.0
                   Gem::Specification
                 elsif Gem.respond_to? :searcher
                   # ruby 1.8/1.9
                   Gem.searcher.init_gemspecs
                 end
      spec = unless searcher.nil?
               searcher.find do |spec|
                 File.fnmatch(File.join(spec.full_gem_path,'*'), file)
               end
             end

      spec.gem_dir
    end


    def self.possible_config_places(file_of_gem=nil)
      root = gem_root_path file_of_gem
      places = OS_DEPENDING_PLACES[os_flavour].dup
      places[:internal] = %w(etc config).map do |place|
        File.join root, place
      end
      places
    end

  end
end