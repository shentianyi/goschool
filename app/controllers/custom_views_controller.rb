class CustomViewController < ApplicationController

  def create
    custom = CustomView.new
    custom.name=params[:name]
    custom.query = params[:q].to_json
    custom.query_type=params[:query_type]
    custom.entity_type = params[:entity_type]

    render custom.save
  end

  def delete
    CustomView.find(params[:id]).destroy
  end


end
