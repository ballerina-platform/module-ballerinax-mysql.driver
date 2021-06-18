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

import ballerina/jballerina.java as _;
import ballerinax/mysql;
import ballerina/sql;

# Represents a MySQL database client.
public client class Client {
    *sql:Client;

    private mysql:Client dbClient;

    # Initializes the MySQL Client.
    #
    # + host - Hostname of the MySQL server to be connected
    # + user - If the MySQL server is secured, the username to be used to connect to the MySQL server
    # + password - The password of the provided username of the database
    # + database - The name fo the database to be connected
    # + port - Port number of the MySQL server to be connected
    # + options - The database-specific JDBC client properties
    # + connectionPool - The `sql:ConnectionPool` object to be used within the JDBC client.
    #                   If there is no `connectionPool` provided, the global connection pool will be used and it will
    #                   be shared by other clients, which have the same properties
    public isolated function init(string host = "localhost", string? user = (), string? password = (), string? database = (),
        int port = 3306, mysql:Options? options = (), sql:ConnectionPool? connectionPool = ()) returns
        sql:Error? {
        self.dbClient = check new mysql:Client(host, user,password, database, port, options,
        connectionPool);
    }

    # Queries the database with the provided query and returns the result as a stream.
    #
    # + sqlQuery - The query, which needs to be executed as a `string` or  an `sql:ParameterizedQuery` when the SQL query has
    #              params to be passed in
    # + rowType - The `typedesc` of the record that should be returned as a result. If this is not provided, the default
    #             column names of the query result set will be used for the record attributes
    # + return - Stream of records in the type of `rowType`. If the `rowType` is not provided, the column names of
    #                  the query are used as record fields and all record fields are optional
    remote isolated function query(string|sql:ParameterizedQuery sqlQuery, typedesc<record {}>? rowType = ())
    returns stream <record {}, sql:Error> {
        return self.dbClient->query(sqlQuery, rowType);
    }

    # Executes the provided DDL or DML SQL queries and returns a summary of the execution.
    #
    # + sqlQuery - The DDL or DML queries such as `INSERT`, `DELETE`, `UPDATE`, etc. as a`string` or an `sql:ParameterizedQuery`
    #              when the query has params to be passed in
    # + return - Summary of the SQL update query as an `sql:ExecutionResult` or `sql:Error`
    #           if any error occurred when executing the query
    remote isolated function execute(string|sql:ParameterizedQuery sqlQuery) returns sql:ExecutionResult|sql:Error {
         return self.dbClient->execute(sqlQuery);
    }

    # Executes a batch of parameterized DDL or DML SQL queries provided 
    # and returns the summary of the execution.
    #
    # + sqlQueries - The DDL or DML queries such as `INSERT`, `DELETE`, `UPDATE`, etc. as an `sql:ParameterizedQuery` with an array
    #                of values passed in
    # + return - Summary of the executed SQL queries as an `sql:ExecutionResult[]`, which includes details such as
    #            the `affectedRowCount` and `lastInsertId`. If one of the commands in the batch fails, this function
    #            will return an `sql:BatchExecuteError`. However, the JDBC driver may or may not continue to process the
    #            remaining commands in the batch after a failure. The summary of the executed queries in case of an error
    #            can be accessed as `(<sql:BatchExecuteError> result).detail()?.executionResults`
    remote isolated function batchExecute(sql:ParameterizedQuery[] sqlQueries) returns sql:ExecutionResult[]|sql:Error {
        return self.dbClient->batchExecute(sqlQueries);
    }

    # Executes a SQL stored procedure and returns the result as a stream with an execution summary.
    #
    # + sqlQuery - The query to execute the SQL stored procedure
    # + rowTypes - The array of `typedesc` of the records that should be returned as a result. If this is not provided,
    #               the default column names of the query result set will be used for the record attributes
    # + return - Summary of the execution is returned in an `sql:ProcedureCallResult` or `sql:Error`
    remote isolated function call(string|sql:ParameterizedCallQuery sqlQuery, typedesc<record {}>[] rowTypes = [])
    returns sql:ProcedureCallResult|sql:Error {
        return self.dbClient->call(sqlQuery, rowTypes);
    }

    # Close the SQL client.
    #
    # + return - Possible error during the closure of the client
    public isolated function close() returns sql:Error? {
        return self.dbClient.close();
    }
}
