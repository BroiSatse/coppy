module Coppy
  module Steps
    class Base
      def self.wrap(&block)
        Class.new(self) do
          define_method(:block, &block)
        end
      end

      def initialize(*args, &block)
        @args = args
        @given_block = block
      end

      def call(env)
        block(env, *@args, &@given_block)
      end
    end
  end
end
