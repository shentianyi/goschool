#encoding: utf-8
class LogininfoSession < Authlogic::Session::Base
  attr_accessor :email, :password, :remember_me
end
