property :ip, String, default: ""
property :fqdn, String, default: ""

email = Chef::EncryptedDataBagItem.load("ultimate", "ultimate")["dns"]["email"]
password = Chef::EncryptedDataBagItem.load("ultimate", "ultimate")["dns"]["password"]

action :create do
	execute "Remove DNS A record for #{fqdn}" do
		command "curl -s -X DELETE --user #{email}:#{password} #{node['dns']['server']}/admin/dns/custom/#{fqdn}"
	end

	execute "Create DNS A record for #{fqdn} with #{ip.empty? ? 'the default value' : 'value' + ip}" do
		command "curl -s -X PUT #{ip.empty? ? '' : '-d ' + ip} --user #{email}:#{password} #{node['dns']['server']}/admin/dns/custom/#{fqdn}"
	end
end
