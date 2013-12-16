#encoding: utf-8
class Presenter
  extend Forwardable
  def self.init_presenters params
    params.map{|param| self.new(param)}
  end

  def self.init_json_presenters params
    params.map{|param| self.new(param).to_json}
  end

end
