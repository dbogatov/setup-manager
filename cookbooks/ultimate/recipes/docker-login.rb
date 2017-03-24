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
username = "dbogatov"

# Login to private registry
docker_registry registry do
	username username
	password data_bag_item("ultimate", "ultimate")["gitlab_token"]
	email "dmytro@dbogatov.org"
end
