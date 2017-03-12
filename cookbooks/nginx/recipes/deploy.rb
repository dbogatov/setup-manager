#
# Cookbook Name:: nginx
# Recipe:: deploy
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "nginx"

%w(curl unzip).each do |package|
	package package do
		action :install
	end
end

bash "Download NGINX artifacts" do
	cwd "/tmp"
	code <<-EOH
		rm -rf nginx && mkdir -p nginx && cd nginx
		curl \
			-s \
			--header "PRIVATE-TOKEN: #{data_bag_item('gitlab', 'token')['value']}" \
			#{node['url']['nginx-artifacts']} \
			> nginx.zip
		unzip nginx.zip > /dev/null
		cp -r dist/* /etc/nginx/
		cd .. && rm -rf nginx
    EOH
	user "root"
	# not_if { ::File.exist?(extract_path) }
end

service "nginx" do
	action [:restart]
end
