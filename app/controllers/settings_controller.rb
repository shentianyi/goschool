#encoding: utf-8
class SettingsController < ApplicationController
   def index
     render :json=>current_tenant.setting
   end
   def update
    
   end
end
