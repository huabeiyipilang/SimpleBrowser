//
//  SBFavoriteDAO.m
//  SimpleBrowser
//
//  Created by Carl Li on 14-10-17.
//  Copyright (c) 2014年 Carl Li. All rights reserved.
//

#import "SBFavoriteDAO.h"
#import "SBDatabase.h"
#import "FavoriteFolder.h"
#import "FavoriteUrl.h"

@implementation SBFavoriteDAO

-(Boolean)initTable{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* documentPath = [paths objectAtIndex:0];
    NSString* dbPath = [documentPath stringByAppendingPathComponent:DB_NAME];
    int res = sqlite3_open([dbPath UTF8String], &db);
    if(res != SQLITE_OK){
        sqlite3_close(db);
        return NO;
    }
    char* errorMsg;
    const char* createTable = "create table if not exists favorite (id integer primary key autoincrement, type integer, title text, fatherid integer, url text, icon text)";
    if(sqlite3_exec(db, createTable, NULL, NULL, &errorMsg) != SQLITE_OK){
        sqlite3_close(db);
        return NO;
    }
    return YES;
}

-(int) addFavorite:(BaseFavorite *)favorite{
    NSString *sql = @"insert into favorite ";
    NSString *args = nil;
    char* errorMsg;
    if ([favorite isMemberOfClass:[FavoriteFolder class]]) {
        FavoriteFolder *folder = (FavoriteFolder *)favorite;
        args = [NSString stringWithFormat:@"(type, title, fatherid, icon) values (%d, %@, %ld, %@)", TYPE_FOLDER, folder.title, (long)folder.fatherId, folder.icon];
    }else if([favorite isMemberOfClass:[FavoriteUrl class]]){
        FavoriteUrl *url = (FavoriteUrl *)favorite;
        args = [NSString stringWithFormat:@"(type, title, fatherid, url) values (%d, \"%@\", %ld, \"%@\")", TYPE_URL, url.title, url.fatherId, url.url];
    }
    sql = [sql stringByAppendingString:args];
    int res = sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errorMsg);
    return res == SQLITE_OK;
}

-(int) removeFavorite:(BaseFavorite *)favorite{
    return 0;
}

-(NSMutableArray *) getFavoriteListByFatherId:(NSInteger)id{
    NSString* sql = [NSString stringWithFormat:@"select * from favorite where fatherid=\"%ld\"", (long)id];
    NSMutableArray *array = [NSMutableArray new];
    sqlite3_stmt *statement;
    int res = sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil);
    if(res == SQLITE_OK){
        while(sqlite3_step(statement) == SQLITE_ROW){
            int type = sqlite3_column_int(statement, 1);
            if(type == TYPE_FOLDER){
                FavoriteFolder *folder = [FavoriteFolder new];
                folder.id = sqlite3_column_int(statement, 0);
                folder.title = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
                folder.fatherId = sqlite3_column_int(statement, 3);
                folder.icon = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
                [array addObject:folder];
            }else if(type == TYPE_URL){
                FavoriteUrl *url = [FavoriteUrl new];
                url.id = sqlite3_column_int(statement, 0);
                url.title = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
                url.fatherId = sqlite3_column_int(statement, 3);
                url.url = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
                [array addObject:url];
            }
        }
    }else{
        
    }
    return array;
}

@end
