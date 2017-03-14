include_recipe "projects"

registry = "registry.dbogatov.org"
username = "dbogatov"
project = "cv-website"
image = "#{registry}/#{username}/#{project}"

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
