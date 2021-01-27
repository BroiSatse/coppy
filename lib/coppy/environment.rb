require 'ostruct'

module Coppy
  class Environment < OpenStruct
    def subenv(hash = {})
      self.class.new(_parent: self, **hash)
    end

    def method_missing(mid, *args)
      return super if mid.to_s.end_with?('=')
      return @table[mid] if @table.key?(mid)
      return _parent.send(mid, *args) if _parent
      super
    end
  end
end
