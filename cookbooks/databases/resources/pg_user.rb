property :name,
	        kind_of: String,
	        required: true

property :password,
	        kind_of: String,
        	required: true

property :cancreatedb,
	        kind_of: [TrueClass, FalseClass],
        	required: false,
        	default: false

property :canlogin,
	        kind_of: [TrueClass, FalseClass],
        	required: false,
        	default: true



action :create do
	execute "Creating a user postgres" do
		command "curl -s -X DELETE --user #{email}:#{password} #{node['dns']['server']}/admin/dns/custom/#{fqdn}"
	end

	execute "Create DNS A record for #{fqdn} with #{ip.empty? ? 'the default value' : 'value' + ip}" do
		command "curl -s -X PUT #{ip.empty? ? '' : '-d ' + ip} --user #{email}:#{password} #{node['dns']['server']}/admin/dns/custom/#{fqdn}"
	end
end
