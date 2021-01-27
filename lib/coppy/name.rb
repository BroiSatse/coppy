module Coppy
  class Name
    def initialize(name)
      @underscore = name
        .gsub(/::/, '/')
        .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
        .gsub(/([a-z\d])([A-Z])/,'\1_\2')
        .tr("-", "_")
        .downcase
    end

    def camelcase
      @underscore.split('_').map(&:capitalize).join
    end
  end
end
