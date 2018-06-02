# java-webapp helm chart

## Prerequisites Details

* Kubernetes 1.8+

## Chart Details
This chart will do the following:

* Deploy Java-web Application

## Installing the Chart

To install the chart with the release name `Java Web App`:

```bash
$ helm install --name java-webapp ./
```

## To pull docker images from Private Docker Registry
```bash
# Create a kubectl secret to pull from private docker registry
$ kubectl create secret docker-registry regsecret --docker-server=https://my.docker.registry --docker-username=<USER> --docker-password=<API_KEY> --docker-email=<EMAIL>
```

Once created, Use it to install Charts
```bash
$ helm install --name java-webapp --set imagePullSecrets=regsecret ./
```

## Configuration

The following table lists the configurable parameters of the Java Web App chart and their default values.

|         Parameter         |           Description             |                         Default                          |
|---------------------------|-----------------------------------|----------------------------------------------------------|
| `initContainerImage`           | Init Container Image       |     `alpine:3.6`                                           |
| `replicaCount`            | Replica count for Java Web App deployment| `1`                                                |
| `imagePullSecrets`        | Docker registry pull secret       |                                                          |
| `ingress.enabled`           | If true, Java Web App Ingress will be created | `false` |
| `ingress.annotations`       | Java Web App Ingress annotations     | `{}` |
| `ingress.hosts`             | Java Web App Ingress hostnames       | `[]` |
| `ingress.tls`               | Java Web App Ingress TLS configuration (YAML) | `[]` |
| `image.repository`| Container repository   | `jainishshah17/express-mongo-crud` |
| `image.tag`| Container tag | `1.0.0` |
| `image.pullPolicy` | Container pull policy | `IfNotPresent`   |
| `service.type` | Java Web App service type | `LoadBalancer`   |
| `service.internalPort` | Java Web App service internal port | `8080`   |
| `service.externalPort` | Java Web App service external port | `80`   |
| `persistence.mountPath` | Java Web App persistence volume mount path | `"/usr/local/tomcat/logs"`   |
| `persistence.enabled` | Java Web App persistence volume enabled | `true`   |
| `persistence.existingClaim` | Provide an existing PersistentVolumeClaim | `nil`   |
| `persistence.storageClass` | Storage class of backing PVC | `nil (uses alpha storage class annotation)`   |
| `persistence.size` | Java Web App persistence volume size | `2Gi`   |
| `resources.requests.memory` | Java Web App initial memory request  |      |
| `resources.requests.cpu`    | Java Web App initial cpu request     |      |
| `resources.limits.memory`   | Java Web App memory limit            |      |
| `resources.limits.cpu`      | Java Web App cpu limit               |      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

### Ingress and TLS
To get Helm to create an ingress object with a hostname, add these two lines to your Helm command:
```
helm install --name hook \
  --set ingress.enabled=true \
  --set ingress.hosts[0]="jainish.company.com" \
  --set service.type=NodePort \
  --set nginx.enabled=false \
  ./
```

If your cluster allows automatic creation/retrieval of TLS certificates (e.g. [kube-lego](https://github.com/jetstack/kube-lego)), please refer to the documentation for that mechanism.

To manually configure TLS, first create/retrieve a key & certificate pair for the address(es) you wish to protect. Then create a TLS secret in the namespace:

```console
kubectl create secret tls chart-example-tls --cert=path/to/tls.cert --key=path/to/tls.key
```

Include the secret's name, along with the desired hostnames, in the Java Web App Ingress TLS section of your custom `values.yaml` file:

```
  ingress:
    ## If true, Java Web Aapp Ingress will be created
    ##
    enabled: true

    ## Java Web Aapp Ingress hostnames
    ## Must be provided if Ingress is enabled
    ##
    hosts:
      - jainish.domain.com
    annotations:
      kubernetes.io/tls-acme: "true"
    ## Java Web Aapp Ingress TLS configuration
    ## Secrets must be manually created in the namespace
    ##
    tls:
      - secretName: chart-example-tls
        hosts:
          - jainish.domain.com
```

* [Source of Example Application](../src) 