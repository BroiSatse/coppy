require "coppy/version"
require "coppy/manifesto"
require "coppy/dsl"
require 'coppy/environment'

require "coppy/steps/copy"
require "coppy/steps/git"

module Coppy
  class Error < StandardError; end

  extend DSL::Module
  step(:copy, Steps::Copy)
  step(:git, Steps::Git)

end
