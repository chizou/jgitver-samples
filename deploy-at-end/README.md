# Usage

## Linux/Unix

```
cd samples/deploy-at-end
mvn clean deploy -DdeployAtEnd=true -DrepositoryURL=$PWD/../repository
```

## Windows

```
cd samples/deploy-at-end
mvn clean deploy -DdeployAtEnd=true -DrepositoryURL=%CD%\..\repository
```
