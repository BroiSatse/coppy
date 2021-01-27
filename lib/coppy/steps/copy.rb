require 'fileutils'

module Coppy
  module Steps
    class Copy
      extend DSL::Module

      step :ignore do |env, pattern|
        env.ignore << pattern
      end

      def initialize(&block)
        @manifesto = Manifesto.load(self.class.dsl, &block)
      end

      def call(env)
        copy_env = Environment.new(ignore: [])
        @manifesto.execute!(copy_env)

        files = Dir.glob(File.join env.source, "**", "*")
        ignored_files = copy_env.ignore.flat_map do |ignore|
          pattern = File.join env.source, ignore
          pattern = File.join(pattern, "**", '*') if File.directory?(pattern)
          Dir.glob(pattern)
        end

        (files - ignored_files).each do |file|
          relative = file.sub(env.source, '')
          target = File.join(env.target, relative)
          FileUtils.mkdir_p(File.dirname target)
          FileUtils.cp(file, target, preserve: true) unless File.directory?(file)
        end
      end
    end
  end
end
