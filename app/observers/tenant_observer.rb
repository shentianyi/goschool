#encoding: utf-8
class TenantObserver<ActiveRecord::Observer
  observe :tenant
  def after_create tenant
    tenant.setting.create(:default_pwd=>'123456')
    tenant.institutions.create(:name=>tenant.name)
  end
end
