#encoding: utf-8

config=YAML.load(File.open("#{Rails.root}/config/config.yml"))
#load path
conf=config['conf']
$AttachTmpPath=conf[:attach_tmp_path]
$AttachPath=conf[:attach_path]
$AttachMaxSize=conf[:attach_max_size]
