class Logininfo < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :email,:crypted_password,:perishable_token,:is_tenant,:tenant_id1

  # acts as tenant
  acts_as_tenant(:tenant)
end
