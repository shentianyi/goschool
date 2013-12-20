class Logininfo < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :email,:password,:password_confirmation,:status,:is_tenant,:tenant_id,:persishable_token

  belongs_to :tenant
  
  has_one :user, :dependent=> :destroy
  has_one :student, :dependent=> :destroy
  has_many :logininfo_roles ,:dependent=> :destroy
  has_many :logininfo_institutions, :dependent=> :destroy

  # acts as tenant
  acts_as_tenant(:tenant)

  # authlogic
  acts_as_authentic do |c|
    c.login_field = :email
    c.validate_email_field = false
  end
  
  #check role
  def check_role role_id
    role_id = self.logininfo_roles.find_by_role_id(role_id)
    if role_id
      return true
    end
    return false
  end
  
  #role change
  def role_change? roles
    self.role_ids == roles ? false : true
  end

  #get role
  def role_ids
    roles = []
    self.logininfo_roles.each do |logininfo_role|
      role = logininfo_role.role_id
      roles << role.to_s
    end
    return roles
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

  #create_tenant_user
  def create_tenant_user!(email,password,password_confirmation,company_name)
    self.email = email
    self.password = password
    self.password_confirmation = password_confirmation

    @tenant = Tenant.new(:company_name=>company_name,
    :edition=>$trail_edition,
    :subscription_status=>SubscriptionStatus::TRIAL)

    begin
      ActiveRecord::Base.transaction do
        @tenant.super_user = self
        @new_role = LogininfoRole.new(:role_id=>500)
        self.logininfo_roles<<@new_role
        self.tenant = @tenant
        self.status = UserStatus::ACTIVE
        self.is_tenant = true
        @tenant.save!
        self.save!
        @tenant.update_attributes :logininfo_id=>self.id
        return self
      end
    rescue ActiveRecord::RecordInvalid => invalid
      raise invalid
    end
  end

  def is_teacher?
    Role.teacher?(self.role_ids)
  end

  def is_admin?
    Role.admin?(self.role_ids)
  end
  
  def is_sale?
    Role.sale?(self.role_ids)
  end

  def is_student?
    Role.student?(self.role_ids)
  end

  def is_manager?
    Role.manager?(self.role_ids)
  end
  
  ## if true 
  def is_employee?
    Role.admin?(self.role_ids) || Role.sale?(role_ids) || Role.manager?(role_ids)
  end
end
