# -*- coding: utf-8 -*-
class StudentStatus
  PORENTIAL=0 #潜在客户
  READING=1   #在读

  def self.display status
    case status
    when PORENTIAL
      '潜在客户'
    when READING
      '在读'
    end
  end
end
