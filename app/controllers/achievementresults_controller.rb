# -*- coding: utf-8 -*-
class AchievementresultsController < ApplicationController
  
  def create
    msg = Msg.new
    msg.result = false
    msg.content = '新建成就失败'

    @achieve = Achievement.find(params[:id])
    if @achieve
      @achieveresult = AchievementResult.new(params[:achievementresult])
      msg.result = @achieveresult.save
    else
      msg.content = '成就类型不存在'
    end
    
    render :json=>msg
  end
end
