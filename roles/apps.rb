name "apps"
description "Role for the all-in-one ultimate server"
# List of recipes and roles to apply. Requires Chef 0.8, earlier versions use 'recipes()'.
run_list [
	"recipe[ultimate::setup-user]",
	"recipe[ultimate::letsencrypt-provision]",
	"recipe[ultimate::letsencrypt-renew]",
	"recipe[ultimate::nginx-deploy]",
	# "recipe[ultimate::cv-website]",
	# "recipe[ultimate::inara-cv]",
]
# Attributes applied if the node doesn't have it set already.
# default_attributes()
# Attributes applied no matter what the node has set already.
# override_attributes()
