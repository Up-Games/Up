//
//  UPSqlite.cpp
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <dispatch/dispatch.h>
#import <sqlite3.h>
#import <string.h>

#import "UPSqlite.h"

namespace UP {

void db_close(sqlite3 *db)
{
    if (db == nullptr) {
        return;
    }
    
    int rc = sqlite3_close(db);
    if (rc != SQLITE_OK) {
        LOG(DB, "*** error closing database: %d", rc);
    }
    
    db = nullptr;
}

void db_begin_transaction(sqlite3 *db)
{
    static const char *sql = "BEGIN TRANSACTION;";
    static sqlite3_stmt *stmt;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (db == nullptr) {
            return;
        }
        db_exec(db, sqlite3_prepare_v2(db, sql, (int)strlen(sql), &stmt, nullptr));
    });
    
    if (db == nullptr) {
        return;
    }
    db_exec(db, sqlite3_reset(stmt));
    db_step(db, sqlite3_step(stmt));
}

void db_commit_transaction(sqlite3 *db)
{
    static const char *sql = "COMMIT TRANSACTION;";
    static sqlite3_stmt *stmt;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (db == nullptr) {
            return;
        }
        db_exec(db, sqlite3_prepare_v2(db, sql, (int)strlen(sql), &stmt, nullptr));
    });
    
    if (db == nullptr) {
        return;
    }
    db_exec(db, sqlite3_reset(stmt));
    db_step(db, sqlite3_step(stmt));
}

void db_rollback_transaction(sqlite3 *db)
{
    static const char *sql = "ROLLBACK TRANSACTION;";
    static sqlite3_stmt *stmt;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (db == nullptr) {
            return;
        }
        db_exec(db, sqlite3_prepare_v2(db, sql, (int)strlen(sql), &stmt, nullptr));
    });
    
    if (db == nullptr) {
        return;
    }
    db_exec(db, sqlite3_reset(stmt));
    db_step(db, sqlite3_step(stmt));
}

}  // namespace UP
