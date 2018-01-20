module "digital-ocean-dolores" {
  source = "git::https://github.com/poseidon/typhoon//digital-ocean/container-linux/kubernetes"

  providers = {
    digitalocean = "digitalocean.default"
    local        = "local.default"
    null         = "null.default"
    template     = "template.default"
    tls          = "tls.default"
  }

  region   = "nyc3"
  dns_zone = "digital-ocean.dbogatov.org"

  cluster_name     = "dolores"
  image            = "coreos-stable"
  controller_count = 1
  controller_type  = "s-1vcpu-1gb"
  worker_count     = 2
  worker_type      = "s-1vcpu-2gb"
  ssh_fingerprints = ["df:a9:7f:e1:e5:e8:c7:3e:2c:c3:a9:ac:7c:bd:e7:a6"]

  # output assets dir
  asset_dir = "/Users/dbogatov/.secrets/clusters/dolores"
}
