require "coppy/version"
require "coppy/manifesto"
require "coppy/dsl"
require 'coppy/environment'

require "coppy/steps/copy"
require "coppy/steps/in_files"
require "coppy/steps/git"
require "coppy/runner"

module Coppy
  class Error < StandardError; end

  extend DSL::Module
  step(:copy, Steps::Copy)
  step(:git, Steps::Git)
  step(:in_files, Steps::InFiles)
end
