# -*- coding: utf-8 -*-
class StudentsController < ApplicationController
  # layout "non_authorized"
  # GET /students
  # GET /students.json
  def index
    @active_left_aside='students'
    @students = Student.all
    @student_presenters = StudentPresenter.init_presenters(@students)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @students }
    end
  end

  # GET /students/1
  # GET /students/1.json
  def show
    @student = Student.find(params[:id])
    @presenter=StudentPresenter.new(@student)
    
    case params[:part]
    when 'class-and-service'
      courses(@student)
    when 'achieve'
      achievements(@student)
    when 'friendship'
      relation(@student)
    when 'consult-record'
      consultation(@student)
    end
    
    @partial ||= params[:part]
    render :partial=>@partial if params[:ajax]

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
    @student = Student.find(params[:id])
    @presenter = StudentPresenter.new(@student)
    render partial:'edit'
  end

  # POST /students
  # POST /students.json
  def create
    msg = Msg.new
    msg.result = false
    begin 
      ActiveRecord::Base.transaction do
        @student = Student.new(params[:student].except(:tags))
        @student.tags = params[:student].slice(:tags)[:tags] if params[:student].has_key?(:tags)
        @default_pwd = current_tenant.setting.default_pwd
        @logininfo = Logininfo.new(:email=>params[:student][:email],:password=>@default_pwd,:password_confirmation=>@default_pwd)
        @new_role = LogininfoRole.new(:role_id=>'300')
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
        puts @student.as_json
        @student.save!
        msg.result = true
      end
    rescue ActiveRecord::RecordInvalid=>invalid
      msg.result = false
      msg.content = invalid.record.errors
    end
    render :json => msg
  end

  # PUT /students/1
  # PUT /students/1.json
  def update
    msg = Msg.new
    msg.result = false
    begin
      @student = Student.find(params[:id])
      @student.tags = params[:student].slice(:tags).strip
      ActiveRecord::Base.transaction do
        if params[:student][:email]
          @student.logininfo.update_attributes!(:email=>params[:student][:email])
          @student.logininfo.save!
        end
        @student.update_attributes(params[:student].except(:tags))
        msg.result = true
      end
    rescue ActiveRecord::RecordInvalid => invalid 
      msg.result = false
      msg.content = invalid.record.errors
    end
    render :json=>msg
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    msg = Msg.new
    msg.result = false
    @sutdent = Student.find_by_id(params[:id])
    if @student
      @student.destroy
    end
    msg.result = true
    render :json=>msg
  end

  # List Search Result
  def fast_search
    results = []
    results = Redis::Search.complete('Student',params[:q],:conditions =>{:tenant_id=>current_tenant.id})
    students = []
    results.slice(0,10).each do |student|
      students<<{:name=>student['title'],:school=>student['school'],:info=>student['email'],:guardian=>student['guardian'],:id=>student['id'],:logininfo_id=>student['logininfo_id']}
    end
    render :json=>students
  end
  
  #nil msg
  def render_all_msg
    unless @student
      @msg.content='不存在此学生'
      render :json=>msg
    end
  end

  private

  def consultation(student)
    @consultations = StudentConsultationPresenter.init_presenters(student.consultations)
  end

  def courses(student)
    
  end
  
  def achievements(student)
    
  end

  def relation(student)
    if student.referrer_id
      @referrer = Logininfo.find(student.referrer_id).student
    end
    @relations = []
    Recommendation.new.get_potential_relation(student.tenant_id,student.id).each do |relation|
      s = Student.find_by_id(relation['id'])
      if s
        @relations<<s
      end
    end
  end
end
