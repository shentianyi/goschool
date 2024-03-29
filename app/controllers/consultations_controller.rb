#encoding: utf-8
class ConsultationsController < ApplicationController
  before_filter :require_user_as_admin, :only=>:destroy

  def index
    
  end

  def create
    msg = Msg.new
    msg.result = false
    msg.content = '添加咨询记录失败！'
    @student = Student.find(params[:id])
    if @student
      @consultation = Consultation.new(params[:consultation])
      @consultation.logininfo_id = current_logininfo.id
      if @consultation.save
        msg.result = true
        msg.object = ConsultationPresenter.new(@consultation).to_json
        puts msg.object.to_json
      end
    else
      msg.content = '学生不存在！'
    end

    render :json=>msg
  end

  def comment
    msg = Msg.new
    msg.result = false
    msg.content = '评论失败！'
    @consultation = Consultation.find(params[:id])
    @consultation.update_attributes(params[:consultation])
    msg.result = true
    msg.object = ConsultationPresenter.new(@consultation).to_json
    render :json=>msg
  end

  def destroy
    msg = Msg.new
    msg.result = false

    @consultation = Consultation.find(params[:id])
    @consultation.destroy
    msg.result = true
    render :json=>msg
  end
end
