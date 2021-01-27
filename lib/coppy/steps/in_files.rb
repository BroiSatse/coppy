require 'fileutils'

module Coppy
  module Steps
    class InFiles
      extend DSL::Module

      step :replace do |env, source, target|
        source = source.call(env) if source.respond_to?(:call)
        target = target.call(env) if target.respond_to?(:call)

        env.file.gsub!(source, target)
      end

      def initialize(*file_patterns, &block)
        @patterns = file_patterns
        @manifesto = Manifesto.load(self.class.dsl, &block)
      end

      def call(env)
        files = @patterns.flat_map { |pattern| Dir.glob(File.join env.target, pattern) }
        files.each do |file_path|
          file = File.read(file_path)
          local_env = env.subenv(
            file: file
          )
          @manifesto.execute!(local_env)
          File.open(file_path, 'w') { |f| f.write local_env.file }
        end
      end
    end
  end
end
