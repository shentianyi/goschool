if ARGV.count==3
	user = User.new(:name=>ARGV[0],:email=>ARGV[0])
	l = Logininfo.new
	l = l.create_tenant_user!(ARGV[0], ARGV[1], ARGV[1], ARGV[2])
	if l
		user.logininfo_id = l.id
		user.tenant = l.tenant
		user.save
		puts "email: #{ARGV[0]}, password: #{ARGV[1]}, company name: #{ARGV[2]}"
	else
		puts "Create Tenant User Failed"
	end
else
  puts 'params error!'
end