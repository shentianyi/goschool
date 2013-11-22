#encoding: utf-8
class Hash
  # for strip hash
  def strip
    self.each_value do |v|
      case v
      when String then v.strip!
      when Array then v.each {|i| i.strip! if i.class==String}
      when Hash then v.strip
      else raise ArgumentError, "Unhandled type #{v.class}"
      end
    end
  end
end
