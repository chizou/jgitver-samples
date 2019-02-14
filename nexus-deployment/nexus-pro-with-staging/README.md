# Nexus staging deployment

This project is a demo how to deploy on a nexus PRO server using staging deployment.

## Infrastructure

The project uses docker-compose to create 2 environments:
- a nexus PRO server
- an available maven environment with a ready to go jgitver based maven project

### Start the environments

`docker-compose up -d`

this will start both a nexus PRO server and a container with our maven project.

#### Nexus

As the nexus server can take several minutes to start you can monitor it's startup by running `docker logs -f nexus-pro-with-staging_nexus-pro_1`.

At some point in time you should see something like:

```
2019-02-10 19:34:28,503+0000 INFO  [jetty-main-1]  org.sonatype.nexus.bootstrap.jetty.JettyServer - Running
2019-02-10 19:34:28,503+0000 INFO  [main] *SYSTEM org.sonatype.nexus.bootstrap.jetty.JettyServer - Started
```

Your nexus server is up and running.

You have now to enter your license information, your host by go to http://localhost:8181/nexus with your browser 
and follow nexus instructions to activate the PRO version. 


#### Maven

We have also started a container with a preconfigured maven project and maven settings able to deploy to the nexus server.

- connect to the container:  
`docker exec -it -w /opt/projects/maven-jgitver-nexus nexus-pro-with-staging_maven_1 /bin/bash`
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
  TODO get log from an env with nexus PRO
  ```
- let's now deploy release 1.0.0
  - `git tag -a -m "release 1.0.0" 1.0.0`
  - `mvn deploy`
  ```
  TODO get log from an env with nexus PRO
  ```
