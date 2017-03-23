include_recipe "ultimate::docker-login"

image = "postgres"
tag = "alpine"

# Pull tagged image
docker_image image do
	action :pull
end

# Run container
docker_container project do
	repo image
	tag tag
	port "5432:5432"
	env [
		"POSTGRES_DB=#{data_bag_item('databases', 'shevastream')['dbname']}",
		"POSTGRES_USER=#{data_bag_item('databases', 'shevastream')['dbuser']}",
		"POSTGRES_PASSWORD=#{data_bag_item('databases', 'shevastream')['dbpassword']}",
	]
	restart_policy "on-failure"
end
