#encoding: utf-8
class InstitutionsController < ApplicationController
  before_filter :init_message ,:only=>[:create,:update,:destroy]
  before_filter :get_institution , :only=>[:update,:show,:destroy]
  before_filter :render_nil_msg , :only=>[:update,:destroy]
  def index
    render :json=>current_tenant.institutions
  end

  def create
    @instance=current_tenant.institutions.build(params[:institution].strip)
    @msg.content=(@msg.result=@instance.save) ? @instance.id :  @instance.errors.messages
    render :json=>@msg
  end

  def show
    render :json=>@instance
  end

  def update
    unless @msg.result=@instance.update_attributes(params[:institution].strip)
    @msg.content=@instance.errors.messages
    end
    render :json=>@msg
  end

  private
  # def get_institution
    # @instance=Institution.find_by_id(params[:id].strip)
  # end

  def render_nil_msg
    unless @instance
      @msg.content='不存在此机构'
      render :json=>msg
    end
  end
end
