# -*- coding: utf-8 -*-
class Posttype < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :value

  def self.display id
    @type = self.find_by_id(id)
    value = '错误类型'
    if @type
      value = @type.value
    end

    return value
  end
end
