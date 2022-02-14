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
import ballerinax/mysql;

type Customer record {|
    int customerId;
    string lastName;
    string firstName;
    int registrationId;
    float creditLimit;
    string country;
|};

// temporary disabling the test because azure db credentials are not configured as git secrets.
// enable it once we add credentials
@test:Config {enable:false}
public function testQueryOperation() returns error? {
    check beforeExample6();

    mysql:Client mysqlClient = check new (host = host, user = user,
            password = password, database = "MYSQL_BBE_1", port = port, options = {serverTimezone: serverTimezone});

    stream<record{}, error?> resultStream =
             mysqlClient->query(`SELECT * FROM Customers`);

    check resultStream.forEach(function(record {} result) {
        io:println("Full Customer details: ", result);
    });

    stream<record{}, error?> resultStream2 =
            mysqlClient->query(`SELECT COUNT(*) AS total FROM Customers`);

    record {|record {} value;|}|error? result = resultStream2.next();
    if result is record {|record {} value;|} {
        io:println("Total rows in customer table : ", result.value["total"]);
    }

    check resultStream.close();

    stream<Customer, sql:Error?> customerStream =
        mysqlClient->query(`SELECT * FROM Customers`, Customer);

    check customerStream.forEach(function(Customer customer) {
        io:println("Full Customer details: ", customer);
    });

    check afterExample6(mysqlClient);
}

function beforeExample6() returns sql:Error? {
    mysql:Client mysqlClient = check new (host = host, user = user, password = password, options = {serverTimezone: serverTimezone});

    _ = check mysqlClient->execute(`CREATE DATABASE MYSQL_BBE_1`);

    _ = check mysqlClient->execute(`
        CREATE TABLE MYSQL_BBE_1.Customers(
            customerId INTEGER NOT NULL AUTO_INCREMENT,
            firstName   VARCHAR(300),
            lastName  VARCHAR(300),
            registrationID INTEGER,
            creditLimit DOUBLE,
            country VARCHAR(300),
            PRIMARY KEY (customerId))
        `);

    _ = check mysqlClient->execute(`INSERT INTO MYSQL_BBE_1.Customers
            (firstName, lastName, registrationID,creditLimit,country) VALUES
            ('Peter','Stuart', 1, 5000.75, 'USA')`);
    _= check mysqlClient->execute(`INSERT INTO MYSQL_BBE_1.Customers
            (firstName, lastName, registrationID,creditLimit,country) VALUES
            ('Dan', 'Brown', 2, 10000, 'UK')`);

    check mysqlClient.close();        
}

function afterExample6(mysql:Client mysqlClient) returns sql:Error? {
    _ = check mysqlClient->execute(`DROP DATABASE MYSQL_BBE_1`);
    check mysqlClient.close();
}
