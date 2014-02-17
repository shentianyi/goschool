#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  include ApplicationHelper
  helper_method :current_user_session, :current_logininfo
  before_filter :require_user
  before_filter :require_active_user
  before_filter :require_user_as_employee
  before_filter :find_current_user_tenant

  set_current_tenant_through_filter

  authorize_resource
  def find_current_user_tenant
    current_tenant=Tenant.find_by_id(current_logininfo.tenant_id)
    set_current_tenant(current_tenant)
  end

  rescue_from CanCan::AccessDenied do |exception|
    render json:{access:false},status:403
  end

  # user must be teacher
  def require_user_as_teacher
    unless current_logininfo.is_teacher?
      error_page_403
    end
  end

  #must be manager
  def require_user_as_manager
    unless current_logininfo.is_manager?
      error_page_403
    end
  end

  #must be admin
  def require_user_as_admin
    unless current_logininfo.is_admin?
      error_page_403
    end
  end

  #must be student
  def require_user_as_student
    unless current_logininfo.is_student?
      error_page_403
    end
  end

  #must be employee
  def require_user_as_employee
    unless current_logininfo.is_employee?
      error_page_403
    end
  end

  def error_page_403
    respond_to do |format|
      format.html {render :file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false}
      format.json { render json: {access:false} ,status: 403 }
    end
  end

  def error_page_404
    respond_to do |format|
      format.html {render :file => File.join(Rails.root, 'public/404.html'), :status => 404, :layout => false}
      format.json { render json: {access:false} ,status: 404 }
    end
  end

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = LogininfoSession.find
  end

  def current_logininfo
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def current_student_id
    return session[:current_student_id]  unless session[:current_student_id].nil?
    if current_logininfo.is_student?
       session[:current_student_id] = Student.find_by_logininfo_id(current_logininfo.id).id
    else
      error_page_404
    end
  end

  # set cancan Ability
  def current_ability
    @current_ability ||= Ability.new(current_logininfo)
  end

  #
  def store_location
    session[:return_to] = request.fullpath
  end

  #filter method
  #need login
  def require_user
    unless current_logininfo
      store_location
      redirect_to new_logininfo_sessions_url
    return false
    end
  end

  #can't be login
  def require_no_user
    if current_logininfo
      store_location
      redirect_to root_url
    return false
    end
  end

  #must be login and active
  def require_active_user
    unless current_logininfo && current_logininfo.status == UserStatus::ACTIVE
      flash[:notice] = "帐号被锁定，请联系管理员！"
      current_user_session.destroy
      redirect_to new_logininfo_sessions_url
    return false
    end
  end
end
