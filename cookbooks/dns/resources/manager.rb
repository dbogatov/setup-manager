property :ip, String, default: ""
property :fqdn, String, default: ""

email = Chef::EncryptedDataBagItem.load("dns", "credentials")["email"]
password = Chef::EncryptedDataBagItem.load("dns", "credentials")["password"]

action :create do
	execute "Remove DNS A record for #{fqdn}" do
		command "curl -s -X DELETE --user #{email}:#{password} #{node['dns']['server']}/admin/dns/custom/#{fqdn}"
	end

	execute "Create DNS A record for #{fqdn} with #{ip.empty? ? 'the default value' : 'value #{ip}'}" do
		command "curl -s -X PUT #{ip.empty? ? '' : '-d ' + ip} --user #{email}:#{password} #{node['dns']['server']}/admin/dns/custom/#{fqdn}"
	end
end
