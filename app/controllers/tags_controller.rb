#encoding: utf-8
class TagsController < ApplicationController
  def fast_search
    render json: TagUtility.new.fast_search(params[:q],10,current_tenant.id).map{|tag| {name:tag}}
    # render json:[{name:'jack'}]
  end
end
