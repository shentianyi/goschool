#encoding: utf-8
class Student < ActiveRecord::Base
  include Redis::Search

  attr_accessible :address, :birthday, :email, :gender, :graduation, :guardian, :guardian_phone, :name, :phone, :school,:referrer_id,:logininfo_id,:image_url,:tenant_id
  
  belongs_to :logininfo
  belongs_to :tenant

  has_one :logininfo_role, :through=>:logininfo
  belongs_to :referrer, :foreign_key => :referrer_id, :class_name => "Logininfo"

  acts_as_tenant(:tenant)

  redis_search_index(:title_field =>:name,
                     :condition_field => [:tenant_id],
                     :ext_fields=>[:email,:address,:school,:guardian])

  def add_tags tags
    Resque.enqueue(TagAdder,self.tenant_id,self.class.name,self.id,tags)
  end
end
