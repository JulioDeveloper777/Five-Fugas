//___________INCLUDES________________//
#include <YSI_Coding/y_hooks>


// //___________MYSQL________________//
// #define MYSQL_HOST        "127.0.0.1"
// #define MYSQL_USER        "root"
// #define MYSQL_PASS        ""
// #define MYSQL_DB        "pcrpg"
// #define MYSQL_DEBUG        true

// new mysql;

// //------------------------------------------------------------------------------

// hook OnGameModeInit()
// {
//     #if MYSQL_DEBUG == true
//         mysql_log(LOG_ERROR | LOG_WARNING | LOG_DEBUG);
//     #endif

//     mysql = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_DB, MYSQL_PASS);

//     if (mysql_errno(mysql) != 0)
//     {
//         print("ERROR: Could not connect to database!");
//         return -1;
//     }
//     else
//     {
//         print("Connected to database successfully!");
//     }
//     return 1;
// }
