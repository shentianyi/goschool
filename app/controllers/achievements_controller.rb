# -*- coding: utf-8 -*-
class AchievementsController < ApplicationController
  # GET /achievements
  # GET /achievements.json
  def index
    @achievements = Achievement.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @achievements }
    end
  end

  # GET /achievements/1
  # GET /achievements/1.json
  def show
    @achievement = Achievement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @achievement }
    end
  end

  # GET /achievements/new
  # GET /achievements/new.json
  def new
    @achievement = Achievement.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @achievement }
    end
  end

  # GET /achievements/1/edit
  def edit
    @achievement = Achievement.find(params[:id])
  end

  # POST /achievements
  # POST /achievements.json
  def create
    msg = Msg.new
    msg.result = false;
    msg.content = '创建成就类型失败'
    if Achievement.find_by_type(params[:achievement][:type])
      msg.content = '已存在该成就类型'
    elsif !AchievementType.valid_type?(params[:achievement][:type])
      msg.content = '系统不支持该成就类型'
    else
      @achievement = Achievement.new(params[:achievement])
      msg.result = @achievement.save
    end
    render :json => msg
  end
  
  def create_sub
    msg = Msg.new
    msg.result = false;
    msg.content = '创建子课程失败'
    @achievement = Achievement.find(params[:id])
    if AchievementType.can_have_sub? @achievement.type
      @new_achieve = Achievement.new(params[:achievement])
      msg.result = @new_achieve.save
    else
      msg.content = '该成就类型不支持创建子课程'
    end

    render :json => msg
  end

  # PUT /achievements/1
  # PUT /achievements/1.json
  def update
    @achievement = Achievement.find(params[:id])

    respond_to do |format|
      if @achievement.update_attributes(params[:achievement])
        format.html { redirect_to @achievement, notice: 'Achievement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @achievement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /achievements/1
  # DELETE /achievements/1.json
  def destroy
    @achievement = Achievement.find(params[:id])
    @achievement.destroy

    respond_to do |format|
      format.html { redirect_to achievements_url }
      format.json { head :no_content }
    end
  end
end
