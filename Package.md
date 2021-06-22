## Package overview

This Package provides the functionality required to access and manipulate data stored in a Azure MySQL database.

**Note:** The MySQL driver JAR is included in this connector. Therefore, you don't need to add the MySQL driver JAR dependency to
 the `Ballerina.toml` file of your project.

## Compatibility

Ballerina Language Version   **Swan Lake Alpha 5**  
MySQL Driver Version         **8.0.20**


### Client
To access a database, you must first create a `mysql:Client` object. 
The examples for creating a MySQL client can be found below.

#### Creating a client
This example shows different ways of creating the Azure MySQL client. 

The `dbClient` receives the host, username, and password. Since the properties are passed in the same order as they are
 defined in the Azure MySQL Client, you can pass them without named params.
 
```ballerina
import ballerinax/azure.mysql
 
mysql:Client|sql:Error dbClient = new ("foo.mysql.database.azure.com", "admin@foo", "password", 
                              "information_schema", 3306);
```

The `dbClient` uses the named params to pass the attributes since it is skipping some params in the constructor. 
Further, the `mysql:Options` property is passed to configure the server time zone in the Azure MySQL client. Normally, the
 server time zone is required when connecting to the Azure MySQL DB server.

```ballerina
import ballerinax/azure.mysql

mysql:Client|sql:Error dbClient = new (host = "foo.mysql.database.azure.com", user = "admin@foo", password = "password",
                              options = {serverTimezone: "UTC"});
```

Similarly, the `dbClient` uses the named params and it provides an unshared connection pool in the type of 
`sql:ConnectionPool` to be used within the client.

```ballerina
import ballerinax/azure.mysql

mysql:Client|sql:Error dbClient = new (host = "foo.mysql.database.azure.com", user = "admin@foo", password = "password",
                              connectionPool = {maxOpenConnections: 5});
```
You can find more details about each property in the `mysql:Client` constructor. 

The `mysql:Client` references and all the operations defined by it will be supported
 by the Azure MySQL client as well.

1. Connection Pooling
2. Querying data
3. Inserting data
4. Updating data
5. Deleting data
6. Batch insert and update data
7. Execute stored procedures
8. Closing client
