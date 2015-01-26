module StackedConfig
  module Layers

    class GenericLayer < SuperStack::Layer

      include StackedConfig::SourceHelper

      def rescan
        set_config_file possible_sources
      end

      def initialize
        rescan
      end

      def possible_config_files(places=possible_sources)
        result = {}
        already_found = false
        browse_files(places) do |file|
          exists = File.readable?(file)
          used = false
          already_found = used = true if exists and not already_found
          result[file] = {
              exists: exists,
              used: used,
              for_layer: [name]
          }
        end
        result
      end

      private


      def browse_files(places, &block)
        places.each do |path_array|
          begin
            potential_config_file = File.join(path_array.map { |path_part| perform_substitutions path_part })
          rescue
            #do nothing
          end
          return unless potential_config_file
          EXTENSIONS.each do |extension|
            file  = potential_config_file.gsub '##EXTENSION##', extension
            yield file
          end
        end
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
end