

include_recipe "ultimate::apt-update"

%w(emacs byobu git htop atop).each do |package|
	package package do
		action :install
	end
end

user = node["user"]["me"]
home = node["etc"]["passwd"][user]["dir"] # Chef DSL

directory "#{home}/.emacs.d" do
	owner user
	group user
	action :create
	recursive true
end

cookbook_file "#{home}/.emacs.d/init.el" do
	source "init.el"
end

directory "#{home}/.byobu" do
	owner user
	group user
	action :create
	recursive true
end

execute "Enable byobu" do
	environment "HOME" => home # old school byobu uses $HOME to create files
	user user
	command "/usr/bin/byobu-enable"
end

cookbook_file "#{home}/.byobu/status" do
	source "status"
end

keys = data_bag_item("ultimate", "ultimate")["sshkeys"]

directory "#{home}/.ssh" do
	owner "root"
	group "root"
	action :create
	recursive true
end

file "#{home}/.ssh/authorized_keys" do
	content keys.join("\n") + "\n"
	mode "0600"
	owner "root"
	group "root"
end

cookbook_file "/etc/ssh/sshd_config" do
	source "sshd_config"
end

service "ssh" do
	action [:restart]
end
