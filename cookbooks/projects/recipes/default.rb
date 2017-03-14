#
# Cookbook Name:: projects
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

docker_installation "default" do
	action :create
end

docker_service_manager "default" do
	action :start
end
