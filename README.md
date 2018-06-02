# Containerize Java micro-services using CircleCI
[![CircleCI](https://circleci.com/gh/jainishshah17/containerize-java-microservice/tree/master.svg?style=svg)](https://circleci.com/gh/jainishshah17/containerize-java-microservice/tree/master)

![Microservices](img/Microservices.png)

#### Command to test maven project:    
```
## Test Java WebApplication 
mvn test
## Test and build Java WebApplication  
mvn clean install
```

#### Command to build docker image and push it to docker registry:

![screenshot](img/Screen_Shot_1.png)

*   Build docker image: ```docker build -t $DOCKER_REGISTRY/java-webapp .```
*   Run docker container: ```docker run -d -p 8080:8080 $DOCKER_REGISTRY/java-webapp```
*   Test container accessing application in browser [http://localhost:8080/](http://localhost:8080/)
*   Login to Artifactory docker registry: ```docker login -u $USER -p $PASSWORD $DOCKER_REGISTRY```
*   Push docker image: ```docker push $DOCKER_REGISTRY/java-webapp```

### Steps to build docker images using CircleCI and push it to docker registry.

##### Step 1:

copy `.circleci/config.yml` to your project

##### Step 2:

Add your project in Circle CI.

##### Step 3:

add Environment Variables `$DOCKER_REGISTRY`, `USER`, `PASSWORD` in Environment Variables settings of Circle CI.

```
$DOCKER_REGISTRY ->  Docker Registry URL 
e.g  $DOCKER_REGISTRY -> https://mycompany.docker.io/

USER -> Docker Registry User which has permission to deploy artifacts.
e.g USER -> admin

PASSWORD -> Password for Docker Registry User.
e.g PASSWORD -> password

```

![screenshot](img/Screen_Shot_2.png)

### Steps to build helm chart and deploy Java Webapp to Kubernetes using helm:
## Prerequisites Details

* Kubernetes 1.8+
* helm 2.8+

##### Step 1: Package helm chart:

```
helm package java-webapp
```

##### Step 2: Deploy Java Webapp to Kubernetes:

```
helm install --name java-webapp  java-webapp-1.0.0.tgz
```

##### Step 3: Check status of helm deployment

```
helm status java-webapp
```

##### Setp 4: Access Java Webapp
```
export SERVICE_IP=$(kubectl get svc --namespace default java-webapp -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo http://$SERVICE_IP:80
```
 
![screenshot](img/Screen_Shot_3.png)

### Congratulation You have just containerize Java micro-services and deployed it to Kubernetes.
