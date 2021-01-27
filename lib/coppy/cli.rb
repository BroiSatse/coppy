require 'thor'
require 'fileutils'
require 'coppy'

module Coppy
  class CLI < Thor
    include Thor::Actions

    def self.exit_on_failure?
      true
    end

    desc "TEMPLATE TARGET", "copies template folder into target, applying .coppy manifest of the template"
    def copy(template_path, target_path)
      Runner.new(template_path, target_path).call
    rescue Coppy::Manifesto::InvalidManifesto => e
      say "Failed to load manifesto. #{e.message}"
      exit(1)
    end

    default_task :copy
  end
end
