#encoding: utf-8
class SearchEngineController < ApplicationController
  skip_load_and_authorize_resource
  layout nil

  #Parameters:
  #search_type: full_text
  #{search_type:full_text,entity_type:"Student",page:1,per_page:20,search_queries:"a string"}
  #search_type: select_query
  #{search_type:"select_query",entity_type:"Student",page:1,per_page:20,search_queries:[{query_type:"StudentName",parameters:[]}}
  def search
    SearchEngine.new.search(params[:search_type],params[:entity_type],params[:q],params[:page],20,current_tenant.id)
  end
end
