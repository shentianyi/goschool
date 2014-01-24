#encoding: utf-8
class CoursesController < ApplicationController
  before_filter :init_message ,:only=>[:edit,:create,:update,:destroy,:subs,:add_teacher]
  before_filter :get_course,:only=>[:edit,:show,:update,:edit,:destroy,:subs,:add_teacher,:detail]
  before_filter :render_nil_msg , :only=>[:edit,:update,:destroy,:subs,:add_teacher]
  before_filter :render_404,:only=>[:edit,:show,:detail]
  
  def index
    @active_left_aside='courses'
    @institutions=current_tenant.institutions
    @courses_records=Course.paginate(:page=>params[:page],:per_page=>10).joins(:institution).select('courses.*,institutions.name as institution_name').order('created_at desc')
    @courses=CoursePresenter.init_presenters(@courses_records)
    @custom_views=CustomView.by_user_id_and_entity_type(current_user.id,'Course').all
  end
   
  def show 
    @active_left_aside='courses'
    @course=CoursePresenter.new(@course)
    case params[:part]
    when 'teacher'
       teachers()
    when 'recommend'
	 recommendations()
    else
	students()
	@partial='student'
    end	
    @partial||=params[:part]
    render partial:@partial if params[:ajax] 
  end

  def edit
    @course=CoursePresenter.new(@course)
    render partial:'edit'
  end

  def create
    @course = current_tenant.courses.build(params[:course].except(:subs).except(:tags).except(:teachers))
    @course.subs=params[:course].slice(:subs)[:subs].values if params[:course].has_key?(:subs)
    @course.tags=params[:course].slice(:tags)[:tags] if params[:course].has_key?(:tags)
    @course.teachs=params[:course].slice(:teachers)[:teachers].values if params[:course].has_key?(:teachers)
    
    @course.subs.each do |sub|
      unless sub[:name].blank?
      is_base=sub[:extro]=='true'
      sub_course=SubCourse.new(:name=>sub[:name],:parent_name=>@course.name,:institution_id=>@course.institution_id,:is_default=>false,:is_base=>is_base)
      sub_course.assign_teachers(sub[:teachers].values) if sub.has_key?(:teachers)
      @course.sub_courses<<sub_course
       if is_base
         @course.has_base=true
        else
          @course.has_sub=true
       end
       end
    end if @course.subs
    
    unless @msg.result=@course.save
    @msg.content=@course.errors.messages
    else
      @msg.content=@course.id
    end
    render :json=>@msg
  end

  def update 
    if params.has_key?(:course)
     @course.tags=params[:course].slice(:tags)[:tags] if params[:course].has_key?(:tags)
     params[:course][:status]= CourseStatus.convert_status(@course.status,params[:course][:status]=='true') if params[:course].has_key?(:status)
     @msg.content= ( @msg.result=@course.update_attributes(params[:course].except(:tags))) ? CourseStatus.display(@course.status)  : @course.errors.messages 
    else
      @course.tags=[]
    end
    @course.add_tags
    render :json=>@msg
  end

  def destroy
    @course.destroy
    @msg.result=true
    render :json=>@msg
  end

  def list_search
    c=[]
    total=10
    l=[6,4]
    ['Course','SubCourse'].each_with_index do |t,i|
      c[i]= Redis::Search.complete(t, params[:q], :conditions => {:tenant_id => current_tenant.id})
    end
    items=[]
    
    l[0]=c[0].count if c[0].count<l[0]
    l[1]=total-l[0]
    
    (c[0].slice(0,l[0])+c[1].slice(0,l[1])).each do |item|
      h={name:item['title'],type:item['type'],id:item['id']} 
      h['name']=item['title']+'-'+item['name'] if !item['is_default'].nil? && !item['is_default']
      items<<h if item['is_default'].nil? || !item['is_default']
    end
    render :json=>items
  end
  
  
  def fast_search
    items=[]
     Redis::Search.complete('Course', params[:q], :conditions => {:tenant_id => current_tenant.id,:institution_id=>params[:institution_id]}).each do |item|
       items<<{id:item['id'],name:item['title']}
     end
     render json:items
  end
  
  def subs
    if @course.has_sub || @course.has_base
      if @course.has_sub
       @subs=@course.sub_courses.where(is_default:false).all
       @msg.content={sub_courses:@subs.map{|s| {id:s.id,name:s.name}},teachers:@subs.first.teacher_names}  
      else
       @subs=@course.sub_courses.order('is_default desc').all
       @msg.content={sub_courses:@subs.map{|s| {id:s.id,name: s.is_default? ? '无' : s.name }},teachers:@subs.first.teacher_names}  
        end
    else
      @msg.content={sub_courses:[],teachers:@course.teacher_names}  
    end
    @msg.result=true
    render json:@msg
  end

 def add_teacher
   unless @course.has_sub
      @teacher_course = TeacherCourse.new(sub_course_id:@course.sub_courses.first.id,user_id:params[:teacher_id])
   @msg.content=(@msg.result=@teacher_course.save) ? @teacher_course.id :  @teacher_course.errors.messages
   else
     @msg.content='课程包含子课程，请先删除子课程'
   end
   render :json=>@msg
 end
 
 def detail
   @course=CoursePresenter.new(@course)
   render partial:'detail'
 end
  private

  def teachers
    @teachers=CourseTeacherPresenter.init_presenters(@course.course_teachers)
  end
  
  def students
    @students=CourseStudentPresenter.init_presenters(@course.course_students)
  end
  
  def recommendations
    @student_presenters=StudentPresenter.init_presenters(@course.recommendations)
  end

  def get_course
    @course=Course.joins(:institution).where(id:params[:id]).select('courses.*,institutions.name as institution_name').first
  end

  def render_nil_msg
    unless @course
      @msg.content='不存在此课程'
      render :json=>@msg
    end
  end
  def render_404
    unless @course
      error_page_404
    end
  end
  
  
end
