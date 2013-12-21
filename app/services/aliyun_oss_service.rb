#encoding: utf-8
require 'aliyun/oss'

class AliyunOssService
  SCHEDULE_BUCKET='goschool-schedule'
  ATTACH_BUCKET='goschool-attach'
  EMAIL_SCHEDULE_LINK_EXPIRES=Time.mktime(2555, 12, 12).to_i
  def self.store_schedule name,data
     Aliyun::OSS::OSSObject.store(name,data,SCHEDULE_BUCKET)
     Aliyun::OSS::OSSObject.url_for(name,SCHEDULE_BUCKET ,expires:EMAIL_SCHEDULE_LINK_EXPIRES)
  end

  def self.store_attachments name,data
    Aliyun::OSS::OSSObject.store(name,data,ATTACH_BUCKET)
    Aliyun::OSS::OSSObject.url_for(name,ATTACH_BUCKET ,expires:EMAIL_SCHEDULE_LINK_EXPIRES)
  end
end
