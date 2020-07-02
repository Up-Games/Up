//
//  UPSqlite.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPAssertions.h>

struct sqlite3;
struct sqlite3_stmt;

namespace UP {

sqlite3 *db_handle_acquire(const char *path, int(^db_create)(sqlite3 *));
void db_close(sqlite3 *);
sqlite3_stmt *db_statement(sqlite3 *, const char *sql);
void db_begin_transaction(sqlite3 *);
void db_commit_transaction(sqlite3 *);
void db_rollback_transaction(sqlite3 *);
void db_close(sqlite3 *);

}  // namespace UP

#define db_exec(H, S) ({ \
    if (!(H)) { \
        return; \
    } \
    int rc = (S); \
        if (rc != SQLITE_OK) { \
        LOG(DB, "*** database error: %d: %s:%d", rc, __FILE__, __LINE__); \
        db_close((H)); \
        return; \
    } \
})

#define db_exec_r(H, S, R) ({ \
    if (!(H)) { \
        return (R); \
    } \
    int rc = (S); \
        if (rc != SQLITE_OK) { \
        LOG(DB, "*** database error: %d: %s:%d", rc, __FILE__, __LINE__); \
        db_close((H)); \
        return (R); \
    } \
})

#define db_step(H, S) ({ \
    if (!(H)) { \
        return; \
    } \
    int rc = (S); \
    if (rc != SQLITE_DONE) { \
        LOG(DB, "*** database error: %d: %s:%d", rc, __FILE__, __LINE__); \
        db_rollback_transaction((H)); \
        db_close((H)); \
        return; \
    } \
})

#define db_step_r(H, S, R) ({ \
    if (!(H)) { \
        return (R); \
    } \
    int rc = (S); \
    if (rc != SQLITE_DONE) { \
        LOG(DB, "*** database error: %d: %s:%d", rc, __FILE__, __LINE__); \
        db_rollback_transaction((H)); \
        db_close((H)); \
        return (R); \
    } \
})

