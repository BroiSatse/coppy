require 'coppy/dsl'

module Coppy
  class Manifesto
    InvalidManifesto = Class.new(StandardError)

    def steps
      @steps ||= []
    end

    def execute!(env)
      steps.each do |step|
        step.call(env)
      end
    end

    def self.load(dsl, &block)
      manifesto = new
      builder = Builder.new(dsl, manifesto)
      builder.instance_exec(&block)

      manifesto
    end

    class Builder
      def initialize(dsl, manifesto)
        @manifesto = manifesto
        @dsl = dsl
      end

      def method_missing(name, *args, &block)
        unless step = @dsl.step(name)
          raise InvalidManifesto, "Unknown step #{name}"
        end
        @manifesto.steps << step.new(*args, &block)
      end

      def respond_to_missing?(name, private = false)
        !!@dsl.step(name) || super
      end
    end
  end
end
