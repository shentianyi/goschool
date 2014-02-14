#encoding: utf-8
class MaterialsController < ApplicationController
  before_filter :init_message, :only => [:create, :update, :destroy]
  before_filter :get_material, :only => [:update, :show, :destroy]
  before_filter :render_nil_msg, :only => [:update, :destroy]

  before_filter :require_user_as_admin, :only => :create_setting_material
  before_filter :require_user_as_manager, :only => [:create_course_material, :create_student_course_material]

  def create
    type=params[:type].to_i
    case type
      when 100
        create_setting_material
      when 200
        create_course_material
      when 300
        creates_student_course_material
    end
    if @material
      @material.logininfo=current_logininfo
      @msg.content=(@msg.result=@material.save) ? @material.id : @material.errors.messages
    else
      @msg.result=false
      @msg.content ='参数错误'
    end
    render :json => @msg
  end

  def update
    @msg.content=@material.errors.messages unless @msg.result=@material.update_attributes(params[:material].strip)
    render :json => @msg
  end

  def destroy
    @material.destroy
    @msg.result=@material.destroyed?
    render :json => @msg
  end

  private
  def get_material
    @material=Material.find_by_id(params[:id])
  end

  def render_nil_msg
    unless @material
      @msg.content='不存在此材料'
      render :json => @msg
    end
  end

  def create_setting_material
    @material=current_tenant.setting.materials.build(params[:material])
  end

  def create_course_material
    @material=@course.materials.build(params[:material]) if @course=Course.find_by_id(params[:id])
  end

  def create_student_course_material
    @material=@student_course.materials.build(params[:material]) if @student_course=StudentCourse.find_by_id(params[:id])
  end
end
