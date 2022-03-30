//
//  AppDelegate.m
//  SQLiteTest
//
//  Created by metanet on 2022/03/30.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"db.sqlite"];
    
    NSLog(@"documentsDirectory : %@", documentsDirectory);
    NSLog(@"filePath : %@", filePath);
    
    sqlite3 *database;
    
    if(sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Error 1");
    }
    
    char *sql = "CREATE TABLE IF NOT EXISTS test(no INTEGER PRIMARY KEY NOT NULL, name varchar)";
    
    if(sqlite3_exec(database, sql, nil, nil, nil) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Error");
    }
    
    sqlite3_stmt *insertStatement;
    
    char *insertSql = "INSERT OR REPLACE INTO test(no, name) VALUES(?, ?)";
    
    if(sqlite3_prepare_v2(database, insertSql, -1, &insertStatement, NULL) == SQLITE_OK) {
        sqlite3_bind_int(insertStatement, 1, 1);
        sqlite3_bind_text(insertStatement, 2, [@"text name" UTF8String], -1, SQLITE_TRANSIENT);
        
        if(sqlite3_step(insertStatement) != SQLITE_DONE) {
            NSLog(@"Error");
        }
    }
    
    sqlite3_stmt *selectStatement;
    
    char *selectSql = "SELECT no, name FROM test";
    
    if(sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        while(sqlite3_step(selectStatement) == SQLITE_ROW) {
            int no = sqlite3_column_int(selectStatement, 0);
            NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 1)];
           
            NSLog(@"no : %i, name : %@", no, name);
        }
    }
    
    sqlite3_finalize(insertStatement);
    sqlite3_finalize(selectStatement);
    
    return YES;
    
    
}


#pragma mark - UISceneSession lifecycle

/*
- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}
*/

@end
