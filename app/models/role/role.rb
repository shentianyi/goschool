#encoding: utf-8
class Role
  @@roles={:'100'=>{:name=>'manager',:display=>'教务'},
    :'200'=>{:name=>'sale',:display=>'销售'},
    :'300'=>{:name=>'student',:display=>'学生'},
    :'400'=>{:name=>'teacher',:display=>'老师'},
    :'500'=>{:name=>'admin',:display=>'管理员'}}

  class<<self
    [:admin?,:teacher?,:student?,:sale?,:manager?].each do |m|
      define_method(m){ |ids|
        role_names(ids).include?(m.to_s.sub(/\?/,''))
        #@roles[id_sym(id)][:name]==m.to_s.sub(/\?/,'')
      }
    end
  end

  def self.role_names ids
    role_names = []
    ids.each do |id|
      role_name = @@roles[id_sym(id)][:name]
      role_names<<role_name
    end
    return role_names
  end

  def self.display id
    @@roles[id_sym(id)][:display]
  end

  def self.id_sym id
    id.to_s.to_sym
  end
end
