#encoding: utf-8
class StudentsController < ApplicationController
  before_filter :get_student, :only=>[:edit,:show,:update,:edit,:destroy,:detail]
  # layout "non_authorized"
  # GET /students
  # GET /students.json
  def index
    @active_left_aside='students'
    @students = Student.paginate(:page=>params[:page],:per_page=>10).order("created_at DESC")
    @student_presenters = StudentPresenter.init_presenters(@students)
    @custom_views=CustomView.by_user_id_and_entity_type(current_logininfo.user.id,'Student').all
    #respond_to do |format|
  #  format.html # index.html.erb
  #  format.json { render json: @students }
  #end
  end

  # GET /students/1
  # GET /students/1.json
  def show
    @active_left_aside='students'
    #@student = Student.find(params[:id])
    @presenter=StudentPresenter.new(@student)
    case params[:part]
      when 'achieve'
        achievements(@student)
      when 'friendship'
        relation(@student)
      when 'consult-record'
        consultation(@student)
      when 'class-performance'
        performance(@student)
      when 'service-material'
        materials(@student)
    else
    @partial = 'class-and-service'
    courses(@student)
    end

    @partial ||= params[:part]
    render :partial => @partial if params[:ajax]

  #respond_to do |formxat|
  #  format.html # show.html.erb
  #  format.json { render json: @student }
  #end
  end

  # GET /students/new
  # GET /students/new.json
  def new
    @student = Student.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student }
    end
  end

  # GET /students/1/edit
  def edit
    #@student = Student.find(params[:id])
    @presenter = StudentPresenter.new(@student)
    render partial: 'edit'
  end

  # POST /students
  # POST /students.json
  def create
    msg = Msg.new
    msg.result = false
    # if not need create account,just give a name
    begin
      ActiveRecord::Base.transaction do
        @student = Student.new(params[:student].except(:tags))
        @student = params[:student].slice(:tags)[:tags] if params[:student].has_key?(:tags)

        account_create = false

        if params[:is_active_account]
          if !params[:student][:email].blank?
            @default_pwd = current_tenant.setting.default_pwd
            @logininfo = Logininfo.new(:email => params[:student][:email], :password => @default_pwd, :password_confirmation => @default_pwd)
            @new_role = LogininfoRole.new(:role_id => '300')
            @logininfo.logininfo_roles<<@new_role
            @logininfo.tenant = current_tenant
            @logininfo.status = UserStatus::ACTIVE
            @logininfo.save!
            account_create = true
          end
        end
        @student.tenant = current_tenant
        if account_create
          @student.logininfo = @logininfo
        end
        @student.save!
        msg.result = true
      end
    rescue ActiveRecord::RecordInvalid=> invalid
      msg.result = false
      msg.content = invalid.record.errors
    end
=begin
    begin
      ActiveRecord::Base.transaction do
        @student = Student.new(params[:student].except(:tags))
        @student.tags = params[:student].slice(:tags)[:tags] if params[:student].has_key?(:tags)
        @default_pwd = current_tenant.setting.default_pwd
        @logininfo = Logininfo.new(:email => params[:student][:email], :password => @default_pwd, :password_confirmation => @default_pwd)
        @new_role = LogininfoRole.new(:role_id => '300')
        @logininfo.logininfo_roles<<@new_role
        @logininfo.tenant = current_tenant
        if params[:is_active_account]
          @logininfo.status = UserStatus::ACTIVE
        else
          @logininfo.status = UserStatus::LOCKED
        end
        @logininfo.save!
        @student.logininfo = @logininfo
        @student.tenant = current_tenant
        @student.save!
        msg.result = true
      end
    rescue ActiveRecord::RecordInvalid => invalid
    msg.result = false
    msg.content = invalid.record.errors
    end
=end
    render :json => msg
  end

  # PUT /students/1
  # PUT /students/1.json
  def update
    msg = Msg.new
    msg.result = false
    begin
      ActiveRecord::Base.transaction do
        if params[:is_active_account] == "true"
          if !@student.logininfo
            @default_pwd = current_tenant.setting.default_pwd
            @logininfo = Logininfo.new(:email => params[:student][:email], :password => @default_pwd, :password_confirmation => @default_pwd)
            @new_role = LogininfoRole.new(:role_id => '300')
            @logininfo.logininfo_roles<<@new_role
            @logininfo.tenant = current_tenant
            @logininfo.status = UserStatus::ACTIVE
            @logininfo.save!
            @student.logininfo = @logininfo
          end
        else
          if @student.logininfo
            @student.logininfo.update_attribute("status",false)
          end
        end

        if params[:student] && !params[:student][:email].blank?
          if @student.logininfo
            @student.logininfo.update_attribute("email",params[:student][:email])
            @student.logininfo.save!
          end
        end

        @student.update_attributes(params[:student].except(:tags)) if params[:student]
        if params.has_key?(:student)
          @student.tags = params[:student].slice(:tags)[:tags]
        else
          @student.tags = []
        end
        @student.add_tags
        msg.result = true
      end
    rescue ActiveRecord::RecordInvalid => invalid
      msg.result = false
      msg.content = invalid.record.errors
    end
=begin
    begin

      if params[:is_active_account]
        @logininfo = @student.logininfo
        status = (params[:is_active_account] == 'true') ? UserStatus::ACTIVE : UserStatus::LOCKED
        @logininfo.update_attribute("status", status)
      end
      ActiveRecord::Base.transaction do
        if params[:student] && params[:student][:email]
          @student.logininfo.update_attributes!(:email => params[:student][:email])
        @student.logininfo.save!
        end

        @student.update_attributes(params[:student].except(:tags)) if params[:student]
        if params.has_key?(:student)
          @student.tags = params[:student].slice(:tags)[:tags]
        else
          @student.tags = []
        end
        @student.add_tags
        msg.result = true
      end
    rescue ActiveRecord::RecordInvalid => invalid
    msg.result = false
    msg.content = invalid.record.errors
    end
=end
    render :json => msg
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    msg = Msg.new
    msg.result = false
    if @student
    @student.destroy
    msg.result = true
    else
      msg.content = '未找到该学生或您没有权限删除Ta'
    end
    render :json => msg
  end

  def detail
    @presenter = StudentPresenter.new(@student)
    render partial:'detail'
  end

  #submit material
  def submit_material
    msg = Msg.new
    msg.result = false
    @material = Material.find_by_id(params[:id])
    if @material
      msg.result = @material.update_attribute('status',params[:status])
    end

    render :json=>msg
  end

  # List Search Result
  def fast_search
    results = []
    results = Redis::Search.complete('Student', params[:q], :conditions => {:tenant_id => current_tenant.id})
    students = []
    results.slice(0, 10).each do |student|
      students<<{:name => student['title'], :school => student['school'], :info => student['email'], :guardian => student['guardian'], :id => student['id'], :logininfo_id => student['logininfo_id']}
    end
    render :json => students
  end

  #nil msg
  def render_all_msg
    unless @student
      @msg.content='不存在此学生'
      render :json => msg
    end
  end

  private

  def performance student
    @shs=@student.student_homeworks.where(marked:true).order('marked_time desc').limit(5).all
    @improved=@student.student_homeworks.where(marked:true,improved:true).count
    @disimproved=@student.student_homeworks.where(marked:true,improved:false).count
    @sub_courses=@student.sub_courses
  end

  def consultation(student)
    @consultations = ConsultationPresenter.init_presenters(student.consultations)
  end

  def courses(student)
    @courses = StudentCoursePresenter.init_presenters(Student.course_detail(student.id).all)
  end

  def achievements(student)
    # achievementtype id
    puts "====================="
    @final = Achievement.find_by_type(AchievementType::FINAL)
    @admit = Achievement.find_by_type(AchievementType::ADMITTED)
    @final_grade = Achievement.find_by_type(AchievementType::FINAL_GRADE)
    puts @final.to_json
    #
    if @final
      @finals = StudentAchievementPresenter.init_presenters(Achievement.achieves(@final.id, student.id))
    end

    if @admit
      @admitted = StudentAchievementPresenter.init_presenters(Achievement.achieves(@admit.id, student.id))
    end

    if @final_grade
      @sub_courses = Achievement.where("type" => AchievementType::SUB_COURSE)
      @final_grades = StudentAchievementPresenter.init_presenters(Achievement.get_result_by_type(AchievementType::SUB_COURSE, student.id))
    end
  end

  def relation(student)
    if student.referrer_id
      @referrer = Logininfo.find(student.referrer_id).student
    end
    @relations = []
    Recommendation.new.get_potential_relation(student.tenant_id, student.id).each do |relation|
      s = Student.find_by_id(relation['reced_id'])
      if s
      @relations<<s
      end
    end
  end

  def materials(student)
    @courses = Course.joins(:student_courses).where('student_courses.student_id = ? AND type = ?',student.id,CourseType::SERVICE).select('student_courses.id as student_course_id,courses.*')
  end

  def get_student
    @student = Student.find(params[:id])
  end
end
