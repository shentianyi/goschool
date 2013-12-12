#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  include ApplicationHelper
  helper_method :current_user_session, :current_user
  before_filter :require_user
  before_filter :require_active_user
  before_filter :find_current_user_tenant

  set_current_tenant_through_filter
  
  authorize_resource

  def find_current_user_tenant
    current_tenant=Tenant.find_by_id(current_user.tenant_id)
    set_current_tenant(current_tenant)
  end

  rescue_from CanCan::AccessDenied do |exception|
    render json:{access:false},status:403
  end

  # user must be teacher
  def require_user_as_teacher
    unless current_user.is_teacher?
      error_page_403
    end
  end
  
  #must be manager
  def require_user_as_manager
    unless current_user.is_manager?
      error_page_403
    end
  end
  
  #must be admin
  def require_user_as_admin
    unless current_user.is_admin?
      error_page_403
    end
  end

  #must be student
  def require_user_as_student
    unless current_user.is_student?
      error_page_403
    end
  end

  def error_page_403
    respond_to do |format|
      format.html {render :file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false}
      format.json { render json: {access:false} ,status: 403 }
    end
  end

  # user must be manager
  def require_user_as_manager
    # unless Role.manager?(current_user.loginingfo_roles)
      # respond_to do |format|
        # format.html {render :file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false}
        # format.json { render json: {access:false} ,status: 403 }
      # end
    # end
  end

  private

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
      redirect_to new_logininfo_sessions_url
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
      redirect_to new_logininfo_sessions_url
    return false
    end
  end
end
