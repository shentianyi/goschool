#encoding: utf-8
class AchievementresultsController < ApplicationController
  
  def create
    msg = Msg.new
    msg.result = false
    msg.content = '新建成就失败'

    @achieve = Achievement.find(params[:id])
    if @achieve
      @achieveresult = Achievementresult.new(params[:achievementresult])

      msg.result = @achieveresult.save
      @presenters = StudentAchievementPresenter.init_presenters(Achievement.get_result_by_id @achieveresult.id)
      msg.object = @presenters[0].to_json
    else
      msg.content = '成就类型不存在'
    end
    
    render :json=>msg
  end

  def destroy
    msg = Msg.new
    msg.result = false
    msg.content = '删除成就失败'
    @achieveres = Achievementresult.find(params[:id])
    if @achieveres
      @achieveres.destroy
      msg.result = true
    else
      msg.content = '成就不存在'
    end

    render :json=>msg
  end

  def update
    msg = Msg.new
    msg.result = false;
    msg.content = '更新成就失败' 
    @result = Achievementresult.find(params[:id])
    @result.update_attributes(params[:result])
    msg.result = true
    
    render :json=>msg
  end
end
