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
        @student = Student.new(params[:Student])
        @default_pwd = current_tenant.setting.default_pwd
        @logininfo = Logininfo.new(:email=>params[:Student][:email],:password=>@default_pwd,:password_confirmation=>@default_pwd)
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
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:Student])
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student = Student.find(params[:id])
    @student.destroy

    respond_to do |format|
      format.html { redirect_to students_url }
      format.json { head :no_content }
    end
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
end
