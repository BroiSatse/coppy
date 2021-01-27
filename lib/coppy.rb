require "coppy/version"
require "coppy/manifesto"
require "coppy/dsl"
require "coppy/steps/copy"
require 'coppy/environment'

module Coppy
  class Error < StandardError; end

  extend DSL::Module
  step(:copy, Steps::Copy)

end
