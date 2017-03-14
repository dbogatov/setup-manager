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

registry = "registry.dbogatov.org"

# Login to private registry
docker_registry registry do
	username username
	password data_bag_item("gitlab", "token")["value"]
	email "dmytro@dbogatov.org"
end
