property :project, String, required: true

action :run do

	dbname = Chef::EncryptedDataBagItem.load("databases", project)["dbname"]
	dbuser = Chef::EncryptedDataBagItem.load("databases", project)["dbuser"]
	dbpassword = Chef::EncryptedDataBagItem.load("databases", project)["dbpassword"]

	include_recipe "ultimate::docker-login"

	image = "mysql"
	tag = "latest"
	directory = "/root/mysql/#{project}"

	# Pull tagged image
	docker_image image do
		repo image
		tag tag
	end

	directory directory do
		owner "root"
		action :create
	end

	# Run container
	docker_container "mysql_#{project}" do
		repo image
		tag tag
		port "#{node['databases'][project]['port']}:3306"
		env [
			"MYSQL_DATABASE=#{dbname}",
			"MYSQL_USER=#{dbuser}",
			"MYSQL_PASSWORD=#{dbpassword}",
			"MYSQL_RANDOM_ROOT_PASSWORD=yes"
		]
		volumes "#{directory}:/var/lib/mysql"
		restart_policy "on-failure"
		kill_after 20
	end
end
