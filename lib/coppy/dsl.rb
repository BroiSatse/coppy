require 'coppy/steps/base'

module Coppy
  class DSL
    def initialize
      @steps = {}
    end

    def step(name)
      steps[name]
    end

    def add_step(name, step_class = nil, &block)
      raise "Cannot define DSL step with both block and class" if step_class && block
      steps[name] = step_class || Steps::Base.wrap(&block)
    end

    module Module
      def dsl
        @dsl ||= DSL.new
      end

      def step(name, step_class = nil, &block)
        dsl.add_step(name, step_class, &block)
      end
    end

    private

    attr_reader :steps
  end
end
