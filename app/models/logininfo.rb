class Logininfo < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :email,:crypted_password,:perishable_token,:is_tenant,:tenant_id,:status
  attr_accessible :user

  belongs_to :tenant
  belongs_to :user

  has_many :logininfo_roles ,dependent: :destroy
  
  # acts as tenant
  acts_as_tenant(:tenant)
  
  # authlogic
  acts_as_authentic do |c|
    c.login_field = :email
  end

  #confirmed?
  def confirmed?
    return true
  end

  #lock user account
  def lock (email)
    logininfo = Logininfo.find_by_email(email)
    if logininfo
      logininfo.status = UserStatus::LOCKED
      return logininfo.save
    else
      return false
    end
  end
end
