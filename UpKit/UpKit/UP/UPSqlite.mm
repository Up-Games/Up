//
//  UPSqlite.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <map>
#import <vector>

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "UPAssertions.h"
#import "UPSqlite.h"

namespace UP {

using db_handle_map = std::map<const char *, sqlite3 *>;
using db_statement_map = std::map<const char *, sqlite3_stmt *>;

db_handle_map &db_handles()
{
    static db_handle_map map;
    return map;
}

db_statement_map &db_prepared_statements()
{
    static db_statement_map map;
    return map;
}

sqlite3_stmt *db_statement(sqlite3 *db, const char *sql)
{
    if (db == nullptr) {
        return nullptr;
    }

    sqlite3_stmt *stmt = nullptr;
    db_statement_map &map = db_prepared_statements();
    auto it = map.find(sql);
    if (it != map.end()) {
        stmt = it->second;
    }
    else {
        int rc = sqlite3_prepare_v2(db, sql, (int)strlen(sql), &stmt, nullptr);
        if (rc == SQLITE_OK) {
            map.emplace(sql, stmt);
        }
        else {
            LOG(DB, "*** error preparing statement: %d", rc);
        }
    }
    return stmt;
}

sqlite3 *db_handle_acquire(const char *path, int(^db_create)(sqlite3 *))
{
    ASSERT(path);

    sqlite3 *db = nullptr;
    db_handle_map &map = db_handles();
    auto it = map.find(path);
    if (it != map.end()) {
        db = it->second;
    }
    else {
        NSString *pathString = [NSString stringWithUTF8String:path];
        NSFileManager *fm = [NSFileManager defaultManager];
        BOOL exists = [fm fileExistsAtPath:pathString];
        int rc = sqlite3_open(path, &db);
        if (rc != SQLITE_OK) {
            LOG(DB, "*** failed to open database: %d", rc);
            return nullptr;
        }
        else {
            if (!exists) {
                rc = db_create(db);
                if (rc != SQLITE_OK) {
                    LOG(DB, "*** failed to create database: %d", rc);
                    return nullptr;
                }
            }
            map.emplace(path, db);
        }
    }
    return db;
}

void db_close(sqlite3 *db)
{
    if (db == nullptr) {
        return;
    }
    
    db_statement_map &stmts_map = db_prepared_statements();
    for (auto it : stmts_map) {
        sqlite3_finalize(it.second);
    }
    stmts_map.clear();

    db_handle_map &handles_map = db_handles();
    for (auto it = handles_map.begin(); it != handles_map.end();) {
        if (it->second == db) {
            handles_map.erase(it);
            break;
        }
        else {
            ++it;
        }
    }

    int rc = sqlite3_close(db);
    if (rc != SQLITE_OK) {
        LOG(DB, "*** error closing database: %d", rc);
    }
}

void db_begin_transaction(sqlite3 *db)
{
    if (db == nullptr) {
        return;
    }
    db_exec(db, sqlite3_exec(db, "BEGIN TRANSACTION;", nullptr, nullptr, nullptr));
}

void db_commit_transaction(sqlite3 *db)
{
    if (db == nullptr) {
        return;
    }
    db_exec(db, sqlite3_exec(db, "COMMIT TRANSACTION;", nullptr, nullptr, nullptr));
}

void db_rollback_transaction(sqlite3 *db)
{
    if (db == nullptr) {
        return;
    }
    db_exec(db, sqlite3_exec(db, "ROLLBACK TRANSACTION;", nullptr, nullptr, nullptr));
}

}  // namespace UP
