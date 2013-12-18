#encoding: utf-8
class InstitutionsController < ApplicationController
  before_filter :init_message ,:only=>[:create,:update,:destroy]
  before_filter :get_institution , :only=>[:update,:show,:destroy]
  before_filter :render_nil_msg , :only=>[:update,:destroy]
  def index
    render :json=>current_tenant.institutions
  end

  def create
    @institution=current_tenant.institutions.build(params[:institution].strip)
    @msg.content=(@msg.result=@institution.save) ? @institution.id :  @institution.errors.messages
    render :json=>@msg
  end

  def show
    render :json=>@institution
  end

  def update
    @msg.content=@institution.errors.messages unless @msg.result=@institution.update_attributes(params[:institution].strip)
    render :json=>@msg
  end

  def destroy
    @institution.destroy
    @msg.result=true
    render :json=>@msg
  end

  private

  def init_message
    @msg=Msg.new
  end

  def get_institution
    @institution=Institution.find_by_id(params[:id])
  end

  def render_nil_msg
    unless @institution
      @msg.content='不存在此机构'
      render :json=>@msg
    end
  end

end
