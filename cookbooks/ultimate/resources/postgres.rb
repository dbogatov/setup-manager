property :project, String, required: true


action :run do

	dbname = Chef::EncryptedDataBagItem.load("databases", project)["dbname"]
	dbuser = Chef::EncryptedDataBagItem.load("databases", project)["dbuser"]
	dbpassword = Chef::EncryptedDataBagItem.load("databases", project)["dbpassword"]

	include_recipe "ultimate::docker-login"

	image = "postgres"
	tag = "alpine"
	directory = "/root/postgres/#{project}"

	# Pull tagged image
	docker_image image do
		repo image
		tag tag
	end

	directory directory do
		owner "root"
		action :create
		recursive true
	end

	# Run container
	docker_container "pg_#{project}" do
		repo image
		tag tag
		port "#{node['databases'][project]['port']}:5432"
		env [
			"POSTGRES_DB=#{dbname}",
			"POSTGRES_USER=#{dbuser}",
			"POSTGRES_PASSWORD=#{dbpassword}"
		]
		volumes "#{directory}:/var/lib/postgresql/data"
		restart_policy "on-failure"
		kill_after 20
	end
end
