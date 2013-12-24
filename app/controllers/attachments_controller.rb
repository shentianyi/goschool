#encoding: utf-8
class AttachmentsController < ApplicationController
  skip_before_filter :require_user_as_employee
  def destroy
    msg = Msg.new
    msg.result = true
    msg.content = "删除附件失败"
    attachment = Attachment.find(params[:id])
    if Attachment.delete? attachment.pathname
      attachment.destroy
      msg.result = true
    end
    render :json => msg
  end
end
