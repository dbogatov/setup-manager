# Setup Manager

* [Create docker pull secret](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/).

```
kubectl create secret docker-registry regsecret --docker-server=registry.dbogatov.org --docker-username=dbogatov --docker-password=TOKEN --docker-email=dmytro@dbogatov.org
```

