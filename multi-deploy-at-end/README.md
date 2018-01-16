# Usage

## Linux/Unix

```
cd samples/multi-deploy-at-end
mvn clean deploy -DdeployAtEnd=true -DrepositoryURL=$PWD/../repository
```

## Windows

```
cd samples/multi-deploy-at-end
mvn clean deploy -DdeployAtEnd=true -DrepositoryURL=%CD%\..\repository
```
