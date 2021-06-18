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

// The `Student` record to represent the database table.
type Student record {
    int id;
    int age;
    string name;
};

@test:Config {enable:true}
public function testStoredProcedures() returns error? {
    // Runs the prerequisite setup for the example.
    check beforeExample3();

    // Initializes the MySQL client.
    Client mysqlClient = check new (host = host, user = user, password = password, database = "MYSQL_BBE", port =
                                                      port, options = {serverTimezone: serverTimezone});

    // Creates a parameterized query to invoke the procedure.
    string name = "George";
    int age = 24;
    sql:ParameterizedCallQuery sqlQuery =
                                `CALL InsertStudent(${name}, ${age})`;

    // Invokes the stored procedure `InsertStudent` with the `IN` parameters.
    sql:ProcedureCallResult retCall = check mysqlClient->call(sqlQuery);
    io:println("Call stored procedure `InsertStudent`." +
        "\nAffected Row count: ", retCall.executionResult?.affectedRowCount);
    check retCall.close();

    // Initializes the `INOUT` and `OUT` parameters.
    sql:InOutParameter id = new (1);
    sql:IntegerOutParameter totalCount = new;
    sql:ParameterizedCallQuery sqlQuery2 =
                        `{CALL GetCount(${id}, ${totalCount})}`;

    // The stored procedure with the `OUT` and `INOUT` parameters is invoked.
    sql:ProcedureCallResult retCall2 = check mysqlClient->call(sqlQuery2);
    io:println("Call stored procedure `GetCount`.");
    io:println("Age of the student with id '1' : ", id.get(int));
    io:println("Total student count: ", totalCount.get(int));
    check retCall2.close();

    // Invokes the stored procedure, which returns the data.
    sql:ProcedureCallResult retCall3 =
            check mysqlClient->call(`{CALL GetStudents()}`, [Student]);
    io:println("Call stored procedure `GetStudents`.");

    // Processes the returned result stream.
    stream<record{}, sql:Error>? result = retCall3.queryResult;
    if result is stream<record{}, sql:Error> {
        stream<Student, sql:Error> studentStream =
                <stream<Student, sql:Error>> result;
        sql:Error? e = studentStream.forEach(function(Student student) {
            io:println("Student details: ", student);
        });
    }
    check retCall3.close();

    // Performs the cleanup after the example.
    check afterExample3(mysqlClient);
}

// Initializes the database as a prerequisite to the example.
function beforeExample3() returns sql:Error? {
    Client mysqlClient = check new (host = host, user = user, password = password, options = {serverTimezone: serverTimezone});

    // Creates a database.
    sql:ExecutionResult result =
        check mysqlClient->execute(`CREATE DATABASE MYSQL_BBE`);

    // Creates a table in the database.
    result = check mysqlClient->execute(`CREATE TABLE MYSQL_BBE.Student
            (id INT AUTO_INCREMENT, age INT, name VARCHAR(255),
            PRIMARY KEY (id))`);

    // Creates the necessary stored procedures using the execute command.
    result = check mysqlClient->execute(`CREATE PROCEDURE
        MYSQL_BBE.InsertStudent (IN pName VARCHAR(255), IN pAge INT)
        BEGIN INSERT INTO Student(age, name) VALUES (pAge, pName); END`);
    result = check mysqlClient->execute(`CREATE PROCEDURE MYSQL_BBE.GetCount
        (INOUT pID INT, OUT totalCount INT) BEGIN SELECT age INTO pID FROM
        Student WHERE id = pID; SELECT COUNT(*) INTO totalCount FROM Student;
        END`);
    result = check mysqlClient->execute(`CREATE PROCEDURE
        MYSQL_BBE.GetStudents() BEGIN SELECT * FROM Student; END`);

    check mysqlClient.close();    
}

// Cleans up the database after running the example.
function afterExample3(Client mysqlClient) returns sql:Error? {
    // Cleans the database.
    sql:ExecutionResult result =
            check mysqlClient->execute(`DROP DATABASE MYSQL_BBE`);

    // Closes the MySQL client.
    check mysqlClient.close();
}
