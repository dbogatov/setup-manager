#
# Cookbook Name:: letsencrypt
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "letsencrypt" do
	action :install
end

directory node["letsencrypt"]["webroot"] do
	owner "root"
	group "root"
	mode 0755
	recursive true
	action :create
end
