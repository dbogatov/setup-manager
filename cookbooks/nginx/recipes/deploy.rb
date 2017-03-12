#
# Cookbook Name:: nginx
# Recipe:: deploy
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w(curl unzip).each do |package|
	package package do
		action :install
	end
end

bash "Download NGINX artifacts" do
	code <<-EOH
		rm -rf /tmp
		mkdir -p /tmp
		cd /tmp
		curl \
			-s \
			--header "PRIVATE-TOKEN: #{data_bag_item('gitlab', 'token')['value']}" \
			#{default['url']['nginx-artifacts']} \
			> nginx.zip
		unzip nginx.zip > /dev/null
		sudo cp -r dist/* /etc/nginx/
		cd ..
		rm -rf /tmp
    EOH
	# not_if { ::File.exist?(extract_path) }
end

service "nginx" do
	action [:enable, :start]
end
