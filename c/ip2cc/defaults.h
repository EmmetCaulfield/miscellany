#pragma once

// The default directory for database files:
// #define IP2CC_DB_ROOT "/var/cache/ip2cc"
#define IP2CC_DB_ROOT "."

// Names of the environment variables that store the database file
// paths:
#define IP2CC_TXTDB_ENVAR "IP2CC_TXTDB"
#define IP2CC_BINDB_ENVAR "IP2CC_BINDB"

// Default filenames for database files:
#define IP2CC_TXTDB_NAME "ip2cc.txt"
#define IP2CC_BINDB_NAME "ip2cc.bin"

// Default fully-qualified paths for database files:
#define IP2CC_TXTDB_PATH IP2CC_DB_ROOT "/" IP2CC_TXTDB_NAME
#define IP2CC_BINDB_PATH IP2CC_DB_ROOT "/" IP2CC_BINDB_NAME
