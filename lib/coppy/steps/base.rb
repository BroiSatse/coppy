module Coppy
  module Steps
    class Base
      def self.wrap(&block)
        Class.new(self) do
          define_method(:block, &block)
        end
      end

      def initialize(*args)
        @args = args
      end

      def call(env)
        block(env, *@args)
      end
    end
  end
end
