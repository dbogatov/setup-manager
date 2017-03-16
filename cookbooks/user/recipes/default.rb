#
# Cookbook Name:: user
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

gem_package "ruby-shadow" do
	action :install
end

user "Create admin user" do
end
