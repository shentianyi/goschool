#encoding: utf-8
class StatusBase
  class<<self
   define_method(:include?){|s|
    self.constants.map { |c| self.const_get(c.to_s)}.include?(s)
   }
  end
end
