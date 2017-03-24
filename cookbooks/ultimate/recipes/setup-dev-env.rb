

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
    cwd home
    user user
    command "/usr/bin/byobu-enable"
end

cookbook_file "#{home}/.byobu/status" do
    source "status"
end

