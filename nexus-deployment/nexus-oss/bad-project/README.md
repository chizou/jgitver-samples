## How to Use

1. Start the `docker-compose` environment like normal
2. Connect to the container, but in the bad project:
`docker exec -it -w /opt/projects/bad-project nexus-oss_maven_1 /bin/bash`
3. Initiate the jgitver-test project:
`./init-project.sh`
4. Next run the bad example. You can execute the script `broken.sh` or execute it one line at a time
5. The `nexus-staging-maven-plugin` isn't outputting any useful output so you can also enable HTTP logging to stderr by running `enable-logger.sh` then re-running `mvn deploy -DskipStaging=true`

## Example of issues

The examples below reference these commands
```
1. git tag 1.0.1 -m "Release 1.0.1"
2. mvn deploy -DskipStaging=true
# jgitver-tester 1.0.1 exists in nexus
3. git checkout cool-feature
4. git merge master -Xtheirs master -m "merge"
5. echo "Hello world" > content
6. git add content pom.xml
7. git commit -m "Hello world"
8. git checkout master
9. git merge cool-feature
10. mvn validate
# first failure occurs here
11. mvn deploy -DskipStaging=true

12. git tag 1.0.2 -m "release 1.0.2"
# second failure occurs here
13. mvn deploy -DskipStaging=true
```

After step 11, we'll see the below output. Although the 400 error doesn't provide much help you can see in the Uploading actions that it's attempting to upload `1.0.1` to `maven-snapshots`. Nexus doesn't like this
```
[INFO] --- nexus-staging-maven-plugin:1.6.3:deploy (default-deploy) @ jgitver-tester ---
[INFO] Performing deferred deploys (gathering into "/opt/projects/bad-project/jgitver-tester/target/nexus-staging/deferred")...
[INFO] Installing /opt/projects/bad-project/jgitver-tester/target/jgitver-tester-1.0.2-SNAPSHOT.jar to /opt/projects/bad-project/jgitver-tester/target/nexus-staging/deferred/com/company/jgitver-tester/1.0.2-SNAPSHOT/jgitver-tester-1.0.2-SNAPSHOT.jar
[INFO] Installing /tmp/pom3472745874606098950.jgitver-maven-plugin.xml to /opt/projects/bad-project/jgitver-tester/target/nexus-staging/deferred/com/company/jgitver-tester/1.0.2-SNAPSHOT/jgitver-tester-1.0.2-SNAPSHOT.pom
[INFO] Deploying remotely...
[INFO] Bulk deploying locally gathered artifacts from directory:
[INFO]  * Bulk deploying locally gathered snapshot artifacts to URL http://nexus-oss:8081/repository/maven-snapshots/
Downloading from nexus: http://nexus-oss:8081/repository/maven-snapshots/com/company/jgitver-tester/1.0.2-SNAPSHOT/maven-metadata.xml
Uploading to nexus: http://nexus-oss:8081/repository/maven-snapshots/com/company/jgitver-tester/1.0.2-SNAPSHOT/jgitver-tester-1.0.2-20190214.204435-1.jar
Uploaded to nexus: http://nexus-oss:8081/repository/maven-snapshots/com/company/jgitver-tester/1.0.2-SNAPSHOT/jgitver-tester-1.0.2-20190214.204435-1.jar (2.0 kB at 16 kB/s)
Uploading to nexus: http://nexus-oss:8081/repository/maven-snapshots/com/company/jgitver-tester/1.0.2-SNAPSHOT/jgitver-tester-1.0.2-20190214.204435-1.pom
Uploaded to nexus: http://nexus-oss:8081/repository/maven-snapshots/com/company/jgitver-tester/1.0.2-SNAPSHOT/jgitver-tester-1.0.2-20190214.204435-1.pom (2.4 kB at 32 kB/s)
Downloading from nexus: http://nexus-oss:8081/repository/maven-snapshots/com/company/jgitver-tester/maven-metadata.xml
Uploading to nexus: http://nexus-oss:8081/repository/maven-snapshots/com/company/jgitver-tester/1.0.2-SNAPSHOT/maven-metadata.xml
Uploaded to nexus: http://nexus-oss:8081/repository/maven-snapshots/com/company/jgitver-tester/1.0.2-SNAPSHOT/maven-metadata.xml (775 B at 15 kB/s)
Uploading to nexus: http://nexus-oss:8081/repository/maven-snapshots/com/company/jgitver-tester/maven-metadata.xml
Uploaded to nexus: http://nexus-oss:8081/repository/maven-snapshots/com/company/jgitver-tester/maven-metadata.xml (285 B at 7.0 kB/s)
Uploading to nexus: http://nexus-oss:8081/repository/maven-snapshots/com/company/jgitver-tester/1.0.1/jgitver-tester-1.0.1.jar
Uploading to nexus: http://nexus-oss:8081/repository/maven-snapshots/com/company/jgitver-tester/1.0.1/jgitver-tester-1.0.1.pom
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  1.870 s
[INFO] Finished at: 2019-02-14T20:44:35Z
[INFO] ------------------------------------------------------------------------
[ERROR] Failed to execute goal org.sonatype.plugins:nexus-staging-maven-plugin:1.6.3:deploy (default-deploy) on project jgitver-tester: Failed to deploy artifacts: Could not transfer artifact com.company:jgitver-tester:jar:1.0.1 from/to nexus (http://nexus-oss:8081/repository/maven-snapshots/): Failed to transfer file http://nexus-oss:8081/repository/maven-snapshots/com/company/jgitver-tester/1.0.1/jgitver-tester-1.0.1.jar with status code 400 -> [Help 1]
[ERROR]
[ERROR] To see the full stack trace of the errors, re-run Maven with the -e switch.
[ERROR] Re-run Maven using the -X switch to enable full debug logging.
[ERROR]
[ERROR] For more information about the errors and possible solutions, please read the following articles:
[ERROR] [Help 1] http://cwiki.apache.org/confluence/display/MAVEN/MojoExecutionException
```


Here is the next error, after step 13. We can see here that after trying to tag a release and uploading, `nexus-staging-maven-plugin` is trying to upload `maven-metadata.xml` from `1.0.2-SNAPSHOT` to the `maven-releases` repo for some reason
```
[INFO] --- nexus-staging-maven-plugin:1.6.3:deploy (default-deploy) @ jgitver-tester ---
[INFO] Performing deferred deploys (gathering into "/opt/projects/bad-project/jgitver-tester/target/nexus-staging/deferred")...
[INFO] Installing /opt/projects/bad-project/jgitver-tester/target/jgitver-tester-1.0.2.jar to /opt/projects/bad-project/jgitver-tester/target/nexus-staging/deferred/com/company/jgitver-tester/1.0.2/jgitver-tester-1.0.2.jar
[INFO] Installing /tmp/pom5073443821964379117.jgitver-maven-plugin.xml to /opt/projects/bad-project/jgitver-tester/target/nexus-staging/deferred/com/company/jgitver-tester/1.0.2/jgitver-tester-1.0.2.pom
[INFO] Deploying remotely...
[INFO] Bulk deploying locally gathered artifacts from directory:
[INFO]  * Bulk deploying locally gathered snapshot artifacts to URL http://nexus-oss:8081/repository/maven-releases/
Uploading to nexus: http://nexus-oss:8081/repository/maven-releases/com/company/jgitver-tester/1.0.2/jgitver-tester-1.0.2.jar
Uploaded to nexus: http://nexus-oss:8081/repository/maven-releases/com/company/jgitver-tester/1.0.2/jgitver-tester-1.0.2.jar (1.9 kB at 20 kB/s)
Uploading to nexus: http://nexus-oss:8081/repository/maven-releases/com/company/jgitver-tester/1.0.2/jgitver-tester-1.0.2.pom
Uploaded to nexus: http://nexus-oss:8081/repository/maven-releases/com/company/jgitver-tester/1.0.2/jgitver-tester-1.0.2.pom (2.3 kB at 51 kB/s)
Downloading from nexus: http://nexus-oss:8081/repository/maven-releases/com/company/jgitver-tester/maven-metadata.xml
Downloaded from nexus: http://nexus-oss:8081/repository/maven-releases/com/company/jgitver-tester/maven-metadata.xml (305 B at 9.0 kB/s)
Uploading to nexus: http://nexus-oss:8081/repository/maven-releases/com/company/jgitver-tester/maven-metadata.xml
Uploaded to nexus: http://nexus-oss:8081/repository/maven-releases/com/company/jgitver-tester/maven-metadata.xml (336 B at 6.7 kB/s)
Downloading from nexus: http://nexus-oss:8081/repository/maven-releases/com/company/jgitver-tester/1.0.2-SNAPSHOT/maven-metadata.xml
[WARNING] Could not transfer metadata com.company:jgitver-tester:1.0.2-SNAPSHOT/maven-metadata.xml from/to nexus (http://nexus-oss:8081/repository/maven-releases/): Failed to transfer file http://nexus-oss:8081/repository/maven-releases/com/company/jgitver-tester/1.0.2-SNAPSHOT/maven-metadata.xml with status code 400
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  1.823 s
[INFO] Finished at: 2019-02-14T20:45:06Z
[INFO] ------------------------------------------------------------------------
[ERROR] Failed to execute goal org.sonatype.plugins:nexus-staging-maven-plugin:1.6.3:deploy (default-deploy) on project jgitver-tester: Failed to retrieve remote metadata com.company:jgitver-tester:1.0.2-SNAPSHOT/maven-metadata.xml: Could not transfer metadata com.company:jgitver-tester:1.0.2-SNAPSHOT/maven-metadata.xml from/to nexus (http://nexus-oss:8081/repository/maven-releases/): Failed to transfer file http://nexus-oss:8081/repository/maven-releases/com/company/jgitver-tester/1.0.2-SNAPSHOT/maven-metadata.xml with status code 400 -> [Help 1]
[ERROR]
[ERROR] To see the full stack trace of the errors, re-run Maven with the -e switch.
[ERROR] Re-run Maven using the -X switch to enable full debug logging.
[ERROR]
[ERROR] For more information about the errors and possible solutions, please read the following articles:
[ERROR] [Help 1] http://cwiki.apache.org/confluence/display/MAVEN/MojoExecutionException
```
