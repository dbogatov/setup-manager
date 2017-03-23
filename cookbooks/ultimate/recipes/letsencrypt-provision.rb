#
# Cookbook Name:: letsencrypt
# Recipe:: certinstall
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "ultimate::letsencrypt-install"

domains = Dir["/etc/nginx/sites-available/*"].map { |path| File.basename(path) }
wwws = []
domains.each do |domain|
	wwws.unshift("www.#{domain}") if domain =~ /^[^\.]+\.(com|org|net)\.?.*$/
end
domains += wwws

interaction = "--non-interactive"
tos = "--agree-tos"
email = "--email #{node['letsencrypt']['email']}"
method = "--standalone"

service "nginx" do
	action [:stop]
end

domains.each do |fqdn|
	next if Dir.exist?("/etc/letsencrypt/live/#{fqdn}")

	dns_manager "Set DNS record for #{fqdn}" do
		fqdn fqdn
		action :create
	end

	execute fqdn do
		command "letsencrypt certonly #{interaction} #{tos} #{email} #{method} -d #{fqdn}"
		ignore_failure true
	end

	dns_manager "Revert DNS record for #{fqdn}" do
		fqdn fqdn
		ip "107.170.3.128"
		action :create
	end
end

Dir["/etc/nginx/sites-available/*"]
	.map { |path| File.basename(path) }
	.each do |fqdn|
	link "/etc/nginx/sites-enabled/#{fqdn}" do
		to "/etc/nginx/sites-available/#{fqdn}"
	end
end

execute "Generating dhparam" do
	command "openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048"
	not_if { ::File.exist?("/etc/ssl/certs/dhparam.pem") }
end

service "nginx" do
	action [:start]
end
