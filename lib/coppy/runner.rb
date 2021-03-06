require 'coppy/manifesto'
require 'coppy/name'

module Coppy
  class Runner
    def initialize(source, target)
      @source = source
      @target = target
    end

    def call
      manifesto = load_manifesto
      env = Environment.new(
        source: source,
        target: target,
        app_name: Name.new(target.split(File::Separator).last)
      )
      manifesto.execute!(env)
    end

    private

    attr_reader :source, :target

    def load_manifesto
      manifesto_source = File.join(source, '.coppy')
      Manifesto.load(Coppy.dsl) { instance_eval File.read(manifesto_source) }
    end
  end
end
