module StackedConfig
  module Layers

    class EnvLayer < SuperStack::Layer


      DEFAULT_LAYER_NAME = 'ENV layer'

      def initialize(filter=nil)
        @filter = filter
        @name = DEFAULT_LAYER_NAME
      end


      def load
        ENV.each_pair { |k,v|

          if @filter.is_a?(Array) and !@filter.include?(k)
            next
          end
          if @filter.is_a?(Regexp) and @filter.match(k).nil?
            next
          end

          self[k] = v
        }
      end

    end

  end
end