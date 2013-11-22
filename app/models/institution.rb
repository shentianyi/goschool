#encoding: utf-8
class Institution < ActiveRecord::Base
    belongs_to :tenant
    attr_accessible :address, :name, :tel
    acts_as_tenant(:tenant)
    validates_presence_of :name,:message=>'机构名称不可为空'
end
