#encoding: utf-8
require 'base_class'

class FileData<CZ::BaseClass
  attr_accessor :type, :oriName, :size, :path, :pathName, :data, :extentiaon, :uuidName

  def default
    {:uuidName=>SecureRandom.uuid}
  end

  def saveFile
    @extention = File.extname(@oriName).downcase
    @pathName = @uuidName + @extention if @pathName.nil?
    File.open(File.join(@path,@pathName),'wb') do |f|
      f.write(@data.read)
    end
  end

  def self.get_size path
    bytes = File.size(path).to_f
    if bytes<10**3
      return "#{bytes} B"
    elsif bytes<10**6
      return "#{(bytes/10**3).round(2)} KB"
    else
      return "#{(bytes/10**6).round(2)} MB"
    end
  end

  def self.get_type path
    case File.extname(path)
    when '.jpg','.jpg','.gif','.bmp','png'
      return 'image'
    when '.doc','.docx'
      return 'doc'
    when '.xls','xlsx'
      return 'excel'
    when '.ppt','pptx'
      return 'ppt'
    when '.pdf'
      return 'pdf'
    when '.zip','.rar','.7z','.tar'
      return 'zip'
    else
      return 'default'
    end
  end
end
