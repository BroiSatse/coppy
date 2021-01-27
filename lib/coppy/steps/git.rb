module Coppy
  module Steps
    class Git
      extend DSL::Module

      step :add_all do |env|
        system "git add ."
      end

      step :commit do |env, message = nil, &block|
        message ||= block.call(env)
        system "git commit -m '#{message}'", out: File::NULL
      end

      def initialize(&block)
        @manifesto = Manifesto.load(self.class.dsl, &block)
      end

      def call(env)
        source_hash = Dir.chdir(env.source) { `git rev-parse HEAD` }
        source_origin = Dir.chdir(env.source) do
          `git remote -v`.each_line
            .map {|line| line.split("\t") }
            .find {|remote, src, fetch_or_push| remote == "origin" && fetch_or_push == "fetch" }
        end

        Dir.chdir(env.target) do
          system "git init", out: File::NULL
          git_env = Environment.new(
            source: Environment.new(
              hash: source_hash,
              remote: source_origin
            )
          )

          @manifesto.execute!(git_env)
        end
      end
    end
  end
end
