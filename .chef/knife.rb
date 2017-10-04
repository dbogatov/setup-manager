current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "dbogatov"
client_key               "#{current_dir}/admin.pem"
validation_client_name   "dstudio-validator"
validation_key           "#{current_dir}/dstudio-validator.pem"
chef_server_url          "https://server.chef.dbogatov.org/organizations/dstudio"
syntax_check_cache_path  "#{ENV['HOME']}/.chef/syntaxcache"
cookbook_path            ["#{current_dir}/../cookbooks"]
