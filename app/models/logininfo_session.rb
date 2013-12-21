#encoding: utf-8
class LogininfoSession < Authlogic::Session::Base
  attr_accessor :email, :password, :remember_me

  generalize_credentials_error_messages "无效的邮箱或密码"

end
