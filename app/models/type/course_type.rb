#encoding: utf-8
class CourseType
  COURSE=100
  SERVICE=200

  def self.display type
    case type
      when COURSE
        '课程'
      when SERVICE
        '服务'
      else
        nil
    end
  end

  class<<self
    self.constants.each do |c|
      define_method(c.downcase.to_s+'?') { |v|
        self.const_get(c.to_s)==v
      }
    end
  end
end
