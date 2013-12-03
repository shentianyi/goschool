# -*- coding: utf-8 -*-
class StudentsController < ApplicationController
  # GET /students
  # GET /students.json
  def index
    @students = Student.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @students }
    end
  end

  # GET /students/1
  # GET /students/1.json
  def show
    @student = Student.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb 
      format.json { render json: @student }
    end
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
  end

  # POST /students
  # POST /students.json
  def create
    msg = Msg.new
    msg.result = false
    begin 
      ActiveRecord::Base.transaction do
        tags = params[:student].slice(:tags).strip
        @student = Student.new(params[:student].except(:tags))
        @student.tags = tags
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
        @student.logininfo = @loginnfo
        @student.tenant = current_tenant
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
  def list_search
    results = []
    results = Redis::Search.query('Student',params[:query],:conditions =>{:tenant_id=>current_tenant.id})
    students = []
    results.slice(0,10).each do |student|
      students<<{:name=>student['name'],:school=>student['school'],:address=>student['address'],:guardian=>student['guardian']}
    end
    render :json=>students
  end

  #get student
  def get_student
    @student=Student.find_by_id(params[:id])
  end
  
  #nil msg
  def render_all_msg
    unless @student
      @msg.content='不存在此学生'
      render :json=>msg
    end
  end

  #create consulting record
  def add_consultation
    msg = Msg.new
    msg.result = false
    @student = Student.find_by_id(params[:id])
    if @student
      @consultation = Consultation.new(params[:consultation])
      @consultation.logininfo = current_user
      student.consultations<<@consultation
      student.save!
      msg.result = true
    else
      msg.content = '学生不存在'
    end
  end

  #search
  def search
    msg = Msg.new
    msg.result = false
    @results = SearchEngine.search(params[:query_string])
    msg.result = false
    msg.content = @results
    render :json=>msg
  end
end
