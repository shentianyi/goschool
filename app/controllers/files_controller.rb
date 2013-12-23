# -*- coding: utf-8 -*-
class FilesController < ApplicationController
  skip_load_and_authorize_resource
  skip_before_filter :require_user_as_employee
  # add attach
  def attach
    msg=Msg.new(:result=>true)
    begin
      msg.object=[]
      params[:files].each do |file|
        if  file.size< $AttachMaxSize
          f=FileData.new(:data=>file,:oriName=>file.original_filename,:path=>$AttachTmpPath)
          f.saveFile
          msg.object<<{:oriName=>f.oriName,:pathName=>f.pathName,:type=>FileData.get_type(f.pathName)}
        else
          msg.result=false
          msg.content="附件大小超过20M"
          break
        end
      end
    rescue Exception=>e
      msg.result=false
      msg.content="附件添加失败"
    end
    render :json=>msg
  end

  # remove attach
  def remove_attach
    msg=Msg.new
    begin
      File.delete(File.join($AttachTmpPath,params[:file]))
      msg.result=true
      msg.object=params[:file]
    rescue Exception=>e
      msg.content="附件删除失败"
    end
    render :json=>msg
  end

  def download
    send_file params[:f],:filename=>RedisHelper.get_attach_name_by_path(params[:f])||params[:f]
  end
end
