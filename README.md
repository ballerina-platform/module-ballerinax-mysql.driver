Ballerina Azure MySQL Library
===================

The Azure MySQL library is one of the external library packages of the <a target="_blank" href="https://ballerina.io
/"> Ballerina</a> language. 

This is specially designed for connecting Azure MySQL DB server and this provides the functionality required to
 access and manipulate the data stored in an Azure MySQL database.
 
The operations below are supported by this connector.
 
 - Pooling connections
 - Querying data
 - Inserting data
 - Updating data
 - Deleting data
 - Updating data in batches
 - Executing stored procedures
 - Closing the client
 
 # Building from the Source
 ## Setting Up the Prerequisites
 
 1. Download and install Java SE Development Kit (JDK) version 11 (from one of the following locations).
 
    * [Oracle](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html)
 
    * [OpenJDK](https://adoptopenjdk.net/)
 
         > **Note:** Set the JAVA_HOME environment variable to the path name of the directory into which you installed JDK.
 
 2. Download and install [Ballerina SL Alpha 5](https://ballerina.io/). 
 
 ## Building the Source
 
 Execute the commands below to build from the source after installing Ballerina Swan Lake Alpha 5 version.
 
 1. To build the library:
 ```shell script
     bal build
 ```
 
 2. To build the module without the tests:
 ```shell script
     bal build --skip-tests
 ```
 # Contributing to Ballerina
 As an open source project, Ballerina welcomes contributions from the community. 
 
 For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/main/CONTRIBUTING.md).
 
 # Code of Conduct
 All contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).
 
 # Useful Links
 * Discuss about code changes of the Ballerina project in [ballerina-dev@googlegroups.com](mailto:ballerina-dev@googlegroups.com).
 * Chat live with us via our [Slack channel](https://ballerina.io/community/slack/).
 * Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
