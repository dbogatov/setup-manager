#
# Cookbook Name:: letsencrypt
# Recipe:: certinstall
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "letsencrypt"

domains = Dir["/etc/nginx/sites-available/*"].map { |path| File.basename(path) }
interaction = "--non-interactive"
tos = "--agree-tos"
email = "--email #{node['letsencrypt']['email']}"
method = "-a webroot"

Dir["/etc/nginx/sites-enabled/*"].each do |site|
	link site do
		action [:delete]
	end
end

link "/etc/nginx/sites-enabled/all-sites-letsencrypt" do
	to "/etc/nginx/sites-available/all-sites-letsencrypt"
end

service "nginx" do
	action [:restart]
end

dns_manager "Set DNS record for pma.dbogatov.org" do
	fqdn "pma.dbogatov.org"
	action :create
end

# domains.each do |domain|
# 	execute domain do
# 		command "letsencrypt certonly #{interaction} #{tos} #{email} #{method} --webroot-path=#{node['letsencrypt']['webroot']} -d #{domain}"
# 	end
# end
