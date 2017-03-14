name "master"
description "Role for the all-in-one ultimate server"
# List of recipes and roles to apply. Requires Chef 0.8, earlier versions use 'recipes()'.
run_list "recipe[nginx::deploy]", "recipe[letsencrypt::certinstall]", "recipe[letsencrypt::certrenew]", "recipe[projects::cv-website]"
# Attributes applied if the node doesn't have it set already.
# default_attributes()
# Attributes applied no matter what the node has set already.
# override_attributes()
