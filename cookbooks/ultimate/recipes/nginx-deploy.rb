#
# Cookbook Name:: nginx
# Recipe:: deploy
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "ultimate::apt-update"

%w(nginx curl unzip).each do |package|
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
		rm /etc/nginx/nginx.conf /etc/nginx/sites-available/* /etc/nginx/snippets/* /etc/nginx/mime.types
		cp -r dist/* /etc/nginx/
    EOH
	user "root"
end

service "nginx" do
	action [:restart]
end
