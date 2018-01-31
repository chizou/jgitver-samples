# Usage

## Linux/Unix

```
cd samples/shade-multi-deploy-at-end
mvn clean deploy -DdeployAtEnd=true -DrepositoryURL=$PWD/../repository
```

## Windows

```
cd samples/shade-multi-deploy-at-end
mvn clean deploy -DdeployAtEnd=true -DrepositoryURL=%CD%\..\repository
```
