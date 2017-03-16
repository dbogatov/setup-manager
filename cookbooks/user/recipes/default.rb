#
# Cookbook Name:: user
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "sudo"

gem_package "ruby-shadow" do
	action :install
end

package "openssl" do
	action :install
end

user "Create admin user" do
	password "$1$JJsvHslV$szsCjVEroftprNn4JHtDi" # `openssl passwd -1 #{data_bag_item("user", "admin")["password"]}`
	username node["user"]["me"]
	manage_home true
end
