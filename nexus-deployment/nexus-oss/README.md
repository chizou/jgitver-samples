# Nexus standard deployment

This project is a demo how to deploy on a nexus OSS server using standard deployment.

## Infrastructure

The project uses docker-compose to create 2 environments:
- a nexus OSS server
- an available maven environment with a ready to go jgitver based maven project

### Start the environments

`docker-compose up -d`

this will start both a nexus OSS server and a container with our maven project.

#### Nexus

As the nexus server can take several minutes to start you can monitor it's startup by running `docker logs -f nexus-oss_nexus-oss_1`.

At some point in time you should see something like:

```
2019-02-10 19:34:28,503+0000 INFO  [jetty-main-1]  org.sonatype.nexus.bootstrap.jetty.JettyServer - Running
2019-02-10 19:34:28,503+0000 INFO  [main] *SYSTEM org.sonatype.nexus.bootstrap.jetty.JettyServer - Started
```

Your nexus server is up and running.
You can access it from your host by going to http://localhost:8181/nexus.


#### Maven

We have also started a container with a preconfigured maven project and maven settings able to deploy to the nexus server.

- connect to the container:  
`docker exec -it -w /opt/projects/maven-jgitver-nexus nexus-oss_maven_1 /bin/bash`
- initialize some git history  
`./init-git-history.sh`
- you should see some commands results for which:
  - we initialized git on our maven project
  - we installed latest jgitver-maven-plugin
  - we tagged s 0.0.1
  - we created a branch and added some file
  - we merged
  - we logged the project history
- the project is ready to be deployed to the nexus server  
`mvn deploy`
  - above command should have deployed version 0.0.2-SNAPSHOT
  ```
  ...
  [INFO] --- maven-deploy-plugin:2.7:deploy (default-deploy) @ jgitver-nexus-sample ---
  ...
  Uploading to nexus: http://nexus-oss:8081/nexus/content/repositories/snapshots/fr/brouillard/oss/jgitver-nexus-sample/0.0.2-SNAPSHOT/maven-metadata.xml
  Uploaded to nexus: http://nexus-oss:8081/nexus/content/repositories/snapshots/fr/brouillard/oss/jgitver-nexus-sample/0.0.2-SNAPSHOT/maven-metadata.xml (614 B at 11 kB/s)
  Uploading to nexus: http://nexus-oss:8081/nexus/content/repositories/snapshots/fr/brouillard/oss/jgitver-nexus-sample/maven-metadata.xml
  Uploaded to nexus: http://nexus-oss:8081/nexus/content/repositories/snapshots/fr/brouillard/oss/jgitver-nexus-sample/maven-metadata.xml (297 B at 6.8 kB/s)
  [INFO] ------------------------------------------------------------------------
  [INFO] BUILD SUCCESS
  [INFO] ------------------------------------------------------------------------
  ...
  ```
- let's now deploy release 1.0.0
  - `git tag -a -m "release 1.0.0" 1.0.0`
  - `mvn deploy`
  ```
  ...
  [INFO] --- maven-deploy-plugin:2.7:deploy (default-deploy) @ jgitver-nexus-sample ---
  Uploading to nexus: http://nexus-oss:8081/nexus/content/repositories/releases/fr/brouillard/oss/jgitver-nexus-sample/1.0.0/jgitver-nexus-sample-1.0.0.pom
  Uploaded to nexus: http://nexus-oss:8081/nexus/content/repositories/releases/fr/brouillard/oss/jgitver-nexus-sample/1.0.0/jgitver-nexus-sample-1.0.0.pom (1.2 kB at 9.3 kB/s)
  ...
  [INFO] ------------------------------------------------------------------------
  [INFO] BUILD SUCCESS
  [INFO] ------------------------------------------------------------------------
  ...
  ```
