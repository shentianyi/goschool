#encoding: utf-8
class InstitutionsController < ApplicationController
    skpi_before_filter :init_message ,:only=>:index
    skpi_before_filter :get_institution , :only=>[:index,:create]
    def index
	render :json=>current_tenant.institutions
    end

    def create
       @institution=current_tenant.institutions.build(params[:institution])
       if @msg.result=@institution.save
          @msg.content=@institution.errors.messages
       end
       render :json=>msg       
    end

    def show
       render :json=>@institution
    end

    def update
	@msg=Msg.new
	if @institution
	    unless @msg.result=@institution.update_attributes(params[:institution])
		@msg.content=@institution.errors.messages
	    end
	else
	    @msg.content='不存在此机构'
	end
	render :json=>@msg
    end

     def destroy
	@msg=Msg.new
	if @institution
	    @msg.result=@institution.destroy
	else
	    @msg.content='不存在此机构'
	end
	render :json=>@msg
    end



    private 
    def init_message
      @msg=Msg.new
    end
    def get_institution
      @institution=Institution.find_by_id(params[:id])
    end
end
