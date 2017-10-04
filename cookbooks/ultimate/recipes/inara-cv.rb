include_recipe "ultimate::docker-login"

registry = "registry.dbogatov.org"
username = "dbogatov"
project = "inara-cv"
image = "#{registry}/#{username}/#{project}"

# Pull tagged image
docker_image image do
	action :pull
end

# Run container
docker_container project do
	repo image
	port "8001:80"
	restart_policy "on-failure"
end
