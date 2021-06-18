// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;
import ballerina/sql;
import ballerina/test;

@test:Config {enable:true}
public function testBatchExecute() returns error? {
    // Runs the prerequisite setup for the example.
    check beforeExample2();

    // Initializes the MySQL client.
    Client mysqlClient = check new (host = host, user = user, password = password, database = "MYSQL_BBE", port =
                                                      port, options = {serverTimezone: serverTimezone});

    // The records to be inserted.
    var insertRecords = [
        {firstName: "Peter", lastName: "Stuart", registrationID: 1,
                                    creditLimit: 5000.75, country: "USA"},
        {firstName: "Stephanie", lastName: "Mike", registrationID: 2,
                                    creditLimit: 8000.00, country: "USA"},
        {firstName: "Bill", lastName: "John", registrationID: 3,
                                    creditLimit: 3000.25, country: "USA"}
    ];

    // Creates a batch parameterized query.
    sql:ParameterizedQuery[] insertQueries =
        from var data in insertRecords
            select  `INSERT INTO Customers
                (firstName, lastName, registrationID, creditLimit, country)
                VALUES (${data.firstName}, ${data.lastName},
                ${data.registrationID}, ${data.creditLimit}, ${data.country})`;

    // Inserts the records with the auto-generated ID.
    sql:ExecutionResult[] result =
                            check mysqlClient->batchExecute(insertQueries);

    int[] generatedIds = [];
    foreach var summary in result {
        generatedIds.push(<int> summary.lastInsertId);
    }
    io:println("\nInsert success, generated IDs are: ", generatedIds, "\n");

    // Checks the data after the batch execution.
    stream<record{}, error> resultStream =
        mysqlClient->query("SELECT * FROM Customers");

    io:println("Data in Customers table:");
    error? e = resultStream.forEach(function(record {} result) {
                 io:println(result.toString());
    });

    // Performs the cleanup after the example.
    check afterExample2(mysqlClient);
}

// Initializes the database as a prerequisite to the example.
function beforeExample2() returns sql:Error? {
    Client mysqlClient = check new (host = host, user = user, password = password, options = {serverTimezone: serverTimezone});

    // Creates a database.
    sql:ExecutionResult result =
        check mysqlClient->execute(`CREATE DATABASE MYSQL_BBE`);
    
    // Creates a table in the database.
    result = check mysqlClient->execute(`CREATE TABLE MYSQL_BBE.Customers
            (customerId INTEGER NOT NULL AUTO_INCREMENT,
            firstName VARCHAR(300), lastName  VARCHAR(300),
            registrationID INTEGER, creditLimit DOUBLE,
            country  VARCHAR(300), PRIMARY KEY (customerId))`);  

    check mysqlClient.close();            
}

// Cleans up the database after running the example.
function afterExample2(Client mysqlClient) returns sql:Error? {
    // Cleans the database.
    sql:ExecutionResult result =
            check mysqlClient->execute(`DROP DATABASE MYSQL_BBE`);
    // Closes the MySQL client.
    check mysqlClient.close();
}
