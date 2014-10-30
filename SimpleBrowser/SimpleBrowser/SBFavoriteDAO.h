//
//  SBFavoriteDAO.h
//  SimpleBrowser
//
//  Created by Carl Li on 14-10-17.
//  Copyright (c) 2014年 Carl Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "BaseFavorite.h"

static NSString* table_name = @"favorite";
static int TYPE_FOLDER = 1;
static int TYPE_URL = 2;

@interface SBFavoriteDAO : NSObject{
    sqlite3* db;
}

-(Boolean) initTable;

-(int) addFavorite:(BaseFavorite *)favorite;

-(int) removeFavorite:(BaseFavorite *)favorite;

-(NSArray*) getFavoriteListByFatherId:(NSInteger)id;

@end
