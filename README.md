# Setup Manager

> When re-deploying change API key, SSH key and domain ownership!

> Run set.dns.sh, test-websites.sh and migrate-spaces.sh

* Follow [this](https://typhoon.psdn.io/digital-ocean/) to create a working Kubernetes cluster.
* [Create docker pull secret](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/).
* Use [this](https://github.com/poseidon/typhoon/blob/c3b0cdddf3310c3d6946ab018cff5229ce96623f/docs/addons/prometheus.md) to set up Prometheus-Grafana.
* Use [this](https://github.com/kubernetes/dashboard/wiki/Creating-sample-user) to get dashboard token.
* Either supply production SSL certificate (key and cert files), or [generate](https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs#generating-ssl-certificates) self signed files.
Make sure all domains are covered ([required](https://github.com/kubernetes/ingress-nginx/issues/616#issuecomment-359498659) by NGINX).
* Populate `infra/.secret.sh` file.
Set `OAUTH2_PROXY_CLIENT_SECRET` variable.
* Use [infra/script.sh](./infra/script.sh) to complete setup.
Example: `./infra/script.sh TOKEN ~/Desktop/certs`.
