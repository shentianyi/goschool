#encoding: utf-8
class CustomView < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_id,:name,:query_type,:entity_type,:query

  def self.by_user_id_and_entity_type(user_id,entity_type)
    where('user_id=? and entity_type=?',user_id,entity_type)
  end


  #throw type exception when it can not be converted
  def query_obj
    begin
      JSON.parse(self.query).symbolize_keys
    rescue

    end

  end
end
