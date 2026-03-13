## Overview

The MySQL driver provides a reliable and high-performance connectivity to MySQL databases. It enables efficient execution of SQL queries, updates, and other database operations. The driver is designed to provide a seamless experience for interacting with MySQL, supporting various data types and advanced features of the database.

### Key Features

- High-performance and reliable database connectivity
- Support for various SQL operations (Query, Execute, Batch)
- Efficient handling of database connections and resources
- Support for database-specific data types and features
- Secure communication with TLS and authentication
- GraalVM compatible for native image builds

## Compatibility

| |   Version    |
|:---|:------------:|
|Ballerina Language | **2201.8.0** |
|MySQL Driver* |  **8.2.0**   |

> *MySQL Connector/J 8.0 is released under GPLv2 License.

## Usage

To add the MySQL driver dependency the project simply import the module as below,

```ballerina
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
```

## Report issues

To report bugs, request new features, start new discussions, view project boards, etc., go to the [Ballerina standard library parent repository](https://github.com/ballerina-platform/ballerina-standard-library).

# Useful Links
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
