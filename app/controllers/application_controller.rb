#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  # helper_method :current_user_session, :current_user
  # before_filter :require_user
  # before_filter :require_active_user
  before_filter :find_current_user_tenant

  set_current_tenant_through_filter
  def find_current_user_tenant
    current_tenant=Tenant.find_by_company_name('Brilliantech')

    set_current_tenant(current_tenant)
  end

  rescue_from CanCan::AccessDenied do |exception|
    render :json=>{:access=>false},:status => 403
  end

  private

  def init_message
    @msg=Msg.new
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = LogininfoSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  # set cancan Ability
  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  #
  def store_location
    session[:return_to] = request.fullpath
  end

  #filter method
  #need login
  def require_user
    unless current_user
      store_location
      redirect_to new_user_session_url
      return false
    end
  end

  #can't be login
  def require_no_user
    if current_user
      store_location
      redirect_to root_url
      return false
    end
  end

  #must be login and active
  def require_active_user
    unless current_user && current_user.status == UserStatus::ACTIVE
      flash[:alert] = "帐号被锁定，请联系管理员！"
      current_user_session.destroy
      redirect_to new_user_session_url
      return false
    end
  end
end
