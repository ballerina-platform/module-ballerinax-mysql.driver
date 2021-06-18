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
This example shows different ways of creating the `mysql:Client`. 

The client can be created with an empty constructor and hence, the client will be initialized with the default properties. 
The first example with the `dbClient1` demonstrates this.

The `dbClient2` receives the host, username, and password. Since the properties are passed in the same order as defined 
in the `jdbc:Client`, you can pass them without named params.

The `dbClient3` uses the named params to pass the attributes since it is skipping some params in the constructor. 
Further, the `mysql:Options` property is passed to configure the SSL and connection timeouts in the MySQL client. 

Similarly, the `dbClient4` uses the named params and it provides an unshared connection pool in the type of 
`sql:ConnectionPool` to be used within the client.

```ballerina
mysql:Client|sql:Error dbClient1 = new ();
mysql:Client|sql:Error dbClient2 = new ("localhost", "rootUser", "rooPass", 
                              "information_schema", 3306);
                              
mysql:Options mysqlOptions = {
  ssl: {
    mode: mysql:SSL_PREFERRED
  },
  connectTimeout: 10
};
mysql:Client|sql:Error dbClient3 = new (user = "rootUser", password = "rootPass",
                              options = mysqlOptions);
mysql:Client|sql:Error dbClient4 = new (user = "rootUser", password = "rootPass",
                              connectionPool = {maxOpenConnections: 5});
```
You can find more details about each property in the `mysql:Client` constructor. 

The `mysql:Client` references sql:Client and all the operations defined by the `sql:Client` will be supported by the `mysql:Client` as well.

1. Connection Pooling
2. Querying data
3. Inserting data
4. Updating data
5. Deleting data
6. Batch insert and update data
7. Execute stored procedures
8. Closing client
