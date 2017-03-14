include_recipe "letsencrypt"

method = "--standalone"

service "nginx" do
	action :stop
end

execute "Renew certificates" do
	command "letsencrypt renew #{method}"
end

service "nginx" do
	action :start
end

cron "Renew certificates" do
	action :create
	command "/usr/bin/letsencrypt renew #{method}"
	mailto "dmytro@dbogatov.org"
	weekday "1"
end
