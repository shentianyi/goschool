#encoding: utf-8
class CourseType
  COURSE=100
  SERVICE=200

  class<<self
    self.constants.each do |c|
      define_method(c.downcase.to_s+'?') { |v|
        self.const_get(c.to_s)==v
      }
    end
  end

  #def self.service?(type)
  #  type==200
  #end

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

end
