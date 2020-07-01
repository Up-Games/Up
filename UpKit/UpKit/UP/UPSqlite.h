//
//  UPSqlite.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPAssertions.h>

struct sqlite3;

namespace UP {

void db_close(sqlite3 *);
void db_begin_transaction(sqlite3 *);
void db_commit_transaction(sqlite3 *);
void db_rollback_transaction(sqlite3 *);

}  // namespace UP

#define db_exec(H, S) ({ \
    int rc = (S); \
        if (rc != SQLITE_OK) { \
        LOG(DB, "*** database error: %d: %s:%d", rc, __FILE__, __LINE__); \
        db_close((H)); \
        return; \
    } \
})

#define db_step(H, S) ({ \
    int rc = (S); \
    if (rc != SQLITE_DONE) { \
        LOG(DB, "*** database error: %d: %s:%d", rc, __FILE__, __LINE__); \
        db_rollback_transaction((H)); \
        db_close((H)); \
        return; \
    } \
})

