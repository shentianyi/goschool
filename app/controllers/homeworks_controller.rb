#encoding: utf-8
class HomeworksController < ApplicationController
  before_filter :init_message ,:only=>[:show,:create,:update,:destroy]
  before_filter :get_homework,:only=>[:show,:update,:destroy]
  before_filter :render_nil_msg , :only=>[:edit,:update,:destroy]

  def create
   attach=params[:homework].slice(:attach)[:attach] if params[:homework].has_key?(:attach)
   @homework = Homework.new(params[:homework].except(:attach))
   Attachment.add(attach,@homework)
   @msg.content=(@msg.result=@homework.save) ? @homework.id :  @homework.errors.messages
    render :json=>@msg
  end
  
  def show
    
  end

  def update
   @msg.content=@homework.errors.messages unless @msg.result=@homework.update_attributes(params[:homework])
    render :json=>@msg
  end

  def destroy
    @homework.destroy
    @msg.result=true
    render :json=>@msg
  end
  
  
   private

  def get_homework
    @homework=Homework.find_by_id(params[:id])
  end

  def render_nil_msg
    unless @homework
      @msg.content='不存在此作业'
      render :json=>msg
    end
  end
  
end
