#encoding: utf-8
class TenantObserver<ActiveRecord::Observer
  observe :tenant
  def after_create tenant
    tenant.setting=Setting.new(:default_pwd=>'123456') 
    tenant.institutions<<Institution.new(:name=>tenant.company_name||'未设置名称')
  end
end
