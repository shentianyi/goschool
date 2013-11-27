#encoding: utf-8
class Presenter
  extend Forwardable
  def initialize(params)
    params.each_pair do |attr,value|
      self.send :"#{attr}=",value
    end unless params.nil?
  end
end
