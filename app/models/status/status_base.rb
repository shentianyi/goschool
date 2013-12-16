#encoding: utf-8
require 'base_class'

class StatusBase
  class<<self
    define_method(:include?){|s| self.constants.map { |c| self.const_get(c.to_s)}.include?(s)}
  end
end

class Menu<CZ::BaseClass
  attr_accessor :display,:value
end 