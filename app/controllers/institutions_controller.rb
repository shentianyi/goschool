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
    unless @msg.result=@institution.save
    @msg.content=@institution.errors.messages
    end
    render :json=>@msg
  end

  def show
    render :json=>@institution
  end

  def update
    unless @msg.result=@institution.update_attributes(params[:institution].strip)
    @msg.content=@institution.errors.messages
    end
    render :json=>@msg
  end

  def destroy
    @institution.destroy
    @msg.result=true
    render :json=>@msg
  end

  private
  def get_institution
    @institution=Institution.find_by_id(params[:id].strip)
  end

  def render_nil_msg
    unless @institution
      @msg.content='不存在此机构'
      render :json=>msg
    end
  end
end