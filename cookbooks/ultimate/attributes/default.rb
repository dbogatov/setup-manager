# user
default["user"]["me"] = "dbogatov"
default["authorization"]["sudo"]["users"] = [default["user"]["me"]]

# nginx
default["url"]["nginx-artifacts"] = "https://git.dbogatov.org/api/v4/projects/15/jobs/artifacts/master/download?job=test"

# letsencrypt
default["letsencrypt"]["webroot"] = "/srv/letsencrypt/"
default["letsencrypt"]["email"] = "dmytro@dbogatov.org"

# dns
default["dns"]["server"] = "https://box.dbogatov.org"

# databases
default["databases"]["shevastream"]["port"] = 5400
default["databases"]["mywebsite"]["port"] = 5401
default["databases"]["visasupport"]["port"] = 5300
