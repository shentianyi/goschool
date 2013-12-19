#encoding: utf-8
class SearchEngineController < ApplicationController
  skip_load_and_authorize_resource
  layout nil
  def search
    SearchEngine.new.seach(params[:search_type],params[:entity_type],params[:q],params[:page])
  end
end
