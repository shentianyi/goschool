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
    ids= SearchEngine.new.search_id(params[:search_type],params[:entity_type],params[:q],params[:page],20,current_tenant.id)
    case params[:entity_type]
    when 'Course'
      @courses=CoursePresenter.init_presenters(Course.detail_by_id(ids).all)
      render partial:'courses/search_result'
    when 'Student'
      @student_presenters = StudentPresenter.init_presenters(Student.where(:id=>ids))
      render partial:'students/search_results'
    else
    render :nothing => true, :status => 200, :content_type => 'text/html'
    end
  end
end
