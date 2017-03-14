include_recipe "projects"

registry = "registry.dbogatov.org"
username = "dbogatov"
project = "cv-website"
image = "#{registry}/#{username}/#{project}"

# Login to private registry
docker_registry registry do
	username username
	password data_bag_item("gitlab", "token")["value"]
	email "dmytro@dbogatov.org"
end

# Pull tagged image
docker_image image do
	action :pull
end

# Run container
docker_container project do
	repo image
	port "8000:80"
	restart_policy "on-failure"
end
