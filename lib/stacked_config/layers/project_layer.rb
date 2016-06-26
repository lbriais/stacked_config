module StackedConfig
  module Layers

    class ProjectLayer < SuperStack::Layer

      attr_accessor :project_file_basename
      attr_reader :started_from_directory

      def initialize(file_or_directory, project_file_basename=nil)
        if Dir.exists? file_or_directory
          raise 'You have to provide the basename of the project file !' if project_file_basename.nil?
          @started_from_directory = File.expand_path file_or_directory
          self.project_file_basename = project_file_basename
        else
          raise "Invalid project file '#{file_or_directory}' !" unless File.readable? file_or_directory
          normalized = File.expand_path file_or_directory
          @started_from_directory = File.dirname normalized
          self.project_file_basename = File.basename normalized
        end
      end

      def file_name
        @file_name ||= find_root_file project_file_basename, started_from_directory
      end

      def project_root
        File.dirname file_name
      end

      def project_file_basename=(file)
        @file_name = nil
        @project_file_basename = file
      end

      private

      def find_root_file(file_basename, initial_directory)
        prev_dir = nil
        cur_dir = initial_directory
        found_file = nil

        raise "Invalid directory '#{initial_directory}'" unless File.readable? initial_directory

        while found_file.nil? and cur_dir != prev_dir
          candidate_file = File.join cur_dir, file_basename
          if File.readable? candidate_file
            found_file = candidate_file
          end
          prev_dir = cur_dir
          cur_dir = File.expand_path '..', cur_dir
        end

        raise "Cannot find any root file named '#{file_basename}' starting from '#{initial_directory}'." if found_file.nil?

        found_file
      end

    end

  end
end
