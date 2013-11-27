class LogininfosController < ApplicationController
  #filter with ability
  #
  def index
    @logininfos = Logininfo.all
    render :json=>@users.as_json
  end
  
  #create logininfo at the same time
  def create
    
  end

  def update
    msg = Msg.new
    @logininfo = Logininfo.find_by_id(params[:id])
    msg.result = false
    if @logininfo && @logininfo.update_attributes(params[:logininfos])
      msg.result = true
      msg.object = @logininfo
    else
      msg.content = @logininfo.errors
    end
    respond_to do |t|
      t.json {render :json=>msg}
      t.js {render :js=> jsonp_str(msg)}
    end
  end
end
