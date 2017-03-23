include_recipe "ultimate::docker-login"

image = "postgres"
tag = "alpine"

# Pull tagged image
docker_image image do
	repo image
	tag tag
end

# Run container
docker_container "pg_shevastream" do
	repo image
	tag tag
	port "#{node['databases']['shevastream']['port']}:5432"
	env [
		"POSTGRES_DB=#{data_bag_item('databases', 'shevastream')['dbname']}",
		"POSTGRES_USER=#{data_bag_item('databases', 'shevastream')['dbuser']}",
		"POSTGRES_PASSWORD=#{data_bag_item('databases', 'shevastream')['dbpassword']}"
	]
	volumes [
		"/var/lib/postgresql/data:/root/postgres/lol"
	]
	restart_policy "on-failure"
end
