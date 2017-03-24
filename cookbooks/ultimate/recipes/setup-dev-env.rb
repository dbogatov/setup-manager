

include_recipe "ultimate::apt-update"

%w(emacs byobu git).each do |package|
	package package do
		action :install
	end
end

user = node["user"]["me"]
home = node["etc"]["passwd"][user]["dir"] # Chef DSL

directory "#{home}/.emacs.d" do
    owner user
    action :create
    recursive true
end

cookbook_file "#{home}/.emacs.d/init.el" do
    source "init.el"
end

directory "#{home}/.byobu" do
    owner user
    action :create
    recursive true
end

cookbook_file "#{home}/.byobu/status" do
    source "status"
end

execute "Enable byobu" do
    user user
    command "byobu-enable"
end
