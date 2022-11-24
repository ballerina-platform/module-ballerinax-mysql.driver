Ballerina MySQL Driver Library
===================

The MySQL Driver library is one of the external library packages of the <a target="_blank" href="https://ballerina.io
/"> Ballerina</a> language. 

This Package bundles the latest MySQL driver so that mysql connector can be used in ballerina projects easily.

## Build from the source

### Set up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 11 (from one of the following locations).
    * [Oracle](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html)
    * [OpenJDK](https://adoptium.net/)

2.  Export your GitHub personal access token with read package permissions as follows.

        export packageUser=<Username>
        export packagePAT=<Personal access token>

### Build the source

Execute the commands below to build from the source.

1. To build the library:

        ./gradlew clean build

2.  Publish ZIP artifact to the local `.m2` repository:

        ./gradlew clean build publishToMavenLocal

3.  Publish the generated artifacts to the local Ballerina central repository:

        ./gradlew clean build -PpublishToLocalCentral=true

4. Publish the generated artifacts to the Ballerina central repository:
        
        ./gradlew clean build -PpublishToCentral=true

## Contribute to Ballerina

As an open source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All contributors are encouraged to read the [Ballerina code of conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`mysql.driver` library](https://lib.ballerina.io/ballerinax/mysql.driver/latest).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
