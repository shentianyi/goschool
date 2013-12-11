#encoding: utf-8
class CoursesController < ApplicationController
  before_filter :init_message ,:only=>[:edit,:create,:update,:destroy,:subs]
  before_filter :get_course,:only=>[:show,:update,:edit,:destroy,:subs]
  before_filter :render_nil_msg , :only=>[:edit,:update,:destroy,:subs]
  
  def index
    @active_left_aside='courses'
    @institutions=current_tenant.institutions
    @courses=CoursePresenter.init_presenters(Course.joins(:institution).select('courses.*,institutions.name as institution_name').all)
  end

  def show
    @course_presenter=CoursePresenter.new(@course)
    case params[:part]
     when 'teachers'
       teachers()
     when 'recommendations'
	 # recommendations()
    else
	students()
	@partal='students'
    end	
    @partial||=params[:part]
    render :partial=>@partial if params[:ajax] 
  end

  def edit
    @msg.result=true
    @msg.object={:course=>@course,:sub_courses=>@course.sub_courses}
    render :json=>@msg
  end

  def create
    @course = current_tenant.courses.build(params[:course].except(:subs).except(:tags).except(:teachers))
    @course.subs=params[:course].slice(:subs)[:subs].values if params[:course].has_key?(:subs)
    @course.tags=params[:course].slice(:tags)[:tags] if params[:course].has_key?(:tags)
    @course.teachs=params[:course].slice(:teachers)[:teachers].values if params[:course].has_key?(:teachers)
      
    @course.subs.each do |sub|
      sub_course=SubCourse.new(:name=>sub[:name],:parent_name=>@course.name,:institution_id=>@course.institution_id,:is_default=>false)
      sub_course.assign_teachers(sub[:teachers].values) if sub.has_key?(:teachers)
      @course.sub_courses<<sub_course
    end if @course.subs
    @course.has_sub=true if @course.subs
    unless @msg.result=@course.save
    @msg.content=@course.errors.messages
    else
      @msg.content=@course.id
    end
    render :json=>@msg
  end

  def update
    @course.tags=params[:course].slice(:tags).strip
    unless @msg.result=@course.update_attributes(params[:course].strip)
    @msg.content=@course.errors.messages
    end
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
      items<<{:name=>item['title'],:content=>item['name'],:type=>item['type'],:id=>item['id']} if(item['is_default']=='false' || item['is_default'].nil?)
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
    @subs=@course.sub_courses.where(is_default:false).all
    if @subs.count>0
       sub=[]
      @sub.each do |s|
        sub<<{id:s.id,name:s.name}
      end
       @msg.content={sub_courses:sub,teachers:@sub.first.teacher_names}  
    else
      @msg.content={sub_courses:[],teachers:@course.teacher_names}  
    end
    @msg.result=true
    render json:@msg
  end

  private

  def teachers
    @teachers=CourseTeacherPresenter.init_presenters(@course.course_teachers)
  end
  
  def students
    @teachers=CourseStudentPresenter.init_presenters(@course.course_students)
  end

  def get_course
    @course=Course.find_by_id(params[:id])
  end

  def render_nil_msg
    unless @course
      @msg.content='不存在此课程'
      render :json=>msg
    end
  end
end
