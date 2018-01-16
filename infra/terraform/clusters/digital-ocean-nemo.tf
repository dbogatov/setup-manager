module "digital-ocean-nemo" {
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

  cluster_name     = "nemo"
  image            = "coreos-stable"
  controller_count = 1
  controller_type  = "2gb"
  worker_count     = 1
  worker_type      = "512mb"
  ssh_fingerprints = ["df:a9:7f:e1:e5:e8:c7:3e:2c:c3:a9:ac:7c:bd:e7:a6"]

  # output assets dir
  asset_dir = "/Users/dbogatov/.secrets/clusters/nemo"
}
