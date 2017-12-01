# Import projects in Eclipse with project dependencies

## 1. launch `build.sh`

the script initializes the demo projects

## 2. Import both projects using "Import as maven project"
  ![Import](images/import.jpg?raw=true "Import")
## 3. Verify properties of `app` projects
  - right click on `app` project
  - select "Java Build Path"
  - goto "Libraries" tab
  - look at maven dependencies, there should be a jar dependency to lib-1.0.0.jar from your MLR
  ![Import](images/deps-lib-1.0.0.jpg?raw=true "Import")
## 4. Let's make a project dependency
  - notice the profile "eclipse" in app pom.xml
  - right click on `app` project
  - select "Maven"
  - in "Active Maven Porfiles", enter _eclipse_
  - verify that checkbox "Resolve dependencies from Workspace projects" is checked
  ![Import](images/eclipse-profile.jpg?raw=true "Import")
  - click apply. Eclipse detects a change in the project configuration and ask to update the configuration. Answer yes.
  ![Import](images/apply-settings.jpg?raw=true "Import")
  - now if you verify again the dependencies of the app project, you will find a _project_ dependency to the library one
  ![Import](images/deps-lib-as-project.jpg?raw=true "Import")

Enjoy Eclipse & [jgitver-maven-plugin](https://github.com/jgitver/jgitver-maven-plugin) !
