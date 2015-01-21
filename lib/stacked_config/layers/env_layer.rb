module StackedConfig
  module Layers

    class EnvLayer < SuperStack::Layer

      attr_reader :filter

      def initialize(filter=nil)
        self.filter = filter
      end

      def filter=(filter)
        raise 'Invalid filter' unless [NilClass, String, Array, Regexp].include? filter.class
        @filter = filter
        load
      end

      def load(*args)
        self.replace read_filtered_environment
        @file_name = :none
        self
      end

      private

      def read_filtered_environment
        return ENV.to_hash if filter.nil?

        if filter.is_a? Array
          ENV.to_hash.select {|k, v| filter.include?(k) }
        elsif  filter.is_a? Regexp
          ENV.to_hash.select {|k, v| k =~ filter }
        elsif filter.is_a? String
          ENV.to_hash.select {|k, v| k == filter }
        end
      end

    end

  end
end