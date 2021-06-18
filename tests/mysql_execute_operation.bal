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
public function testExecuteOperations() returns error? {
    // Runs the prerequisite setup for the example.
    check beforeExample5();

    // Initializes the MySQL client.
    Client mysqlClient = check new (host = host, user = user, password = password, database = "MYSQL_BBE_2", port =
    port, options = {serverTimezone: serverTimezone});

    float newCreditLimit = 15000.5;

    // Creates a parameterized query for the record update.
    sql:ParameterizedQuery updateQuery =
            `UPDATE Customers SET creditLimit = ${newCreditLimit}
            where customerId = 1`;

    sql:ExecutionResult result = check mysqlClient->execute(updateQuery);
    io:println("Updated Row count: ", result?.affectedRowCount);

    string firstName = "Dan";

    // Creates a parameterized query for deleting the records.
    sql:ParameterizedQuery deleteQuery =
            `DELETE FROM Customers WHERE firstName = ${firstName}`;

    result = check mysqlClient->execute(deleteQuery);
    io:println("Deleted Row count: ", result.affectedRowCount);

    // Performs the cleanup after the example.
    check afterExample5(mysqlClient);
}

// Initializes the database as a prerequisite to the example.
function beforeExample5() returns sql:Error? {
    Client mysqlClient = check new (host = host, user = user, password = password, options = {serverTimezone: serverTimezone});

    // Creates a database.
    sql:ExecutionResult result =
        check mysqlClient->execute(`CREATE DATABASE MYSQL_BBE_2`);

    //Creates a table in the database.
    result = check mysqlClient->execute(`CREATE TABLE MYSQL_BBE_2.Customers
            (customerId INTEGER NOT NULL AUTO_INCREMENT, firstName  
            VARCHAR(300), lastName  VARCHAR(300), registrationID INTEGER, 
            creditLimit DOUBLE, country VARCHAR(300),
            PRIMARY KEY (customerId))`);

    // Inserts data into the table. The result will have the `affectedRowCount`
    // and `lastInsertedId` with the auto-generated ID of the last row.
    result = check mysqlClient->execute(`INSERT INTO MYSQL_BBE_2.Customers
            (firstName, lastName, registrationID,creditLimit,country) VALUES
            ('Peter','Stuart', 1, 5000.75, 'USA')`);
    result = check mysqlClient->execute(`INSERT INTO MYSQL_BBE_2.Customers
            (firstName, lastName, registrationID,creditLimit,country) VALUES
            ('Dan', 'Brown', 2, 10000, 'UK')`);

    io:println("Rows affected: ", result.affectedRowCount);
    io:println("Generated Customer ID: ", result.lastInsertId);

    check mysqlClient.close();
}

// Cleans up the database after running the example.
function afterExample5(Client mysqlClient) returns sql:Error? {
    // Cleans the database.
    sql:ExecutionResult result =
            check mysqlClient->execute(`DROP DATABASE MYSQL_BBE_2`);
    // Closes the MySQL client.
    check mysqlClient.close();
}
