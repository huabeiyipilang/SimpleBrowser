//
//  SBFavoriteManager.h
//  SimpleBrowser
//
//  Created by Carl Li on 14-10-16.
//  Copyright (c) 2014年 Carl Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SBFavoriteManager : NSObject

+(SBFavoriteManager *) getInstance;

-(int) addFavoriteUrl:(NSString *)url title:(NSString *)title fatherId:(NSInteger)fatherId;

-(NSMutableArray *) getFavoriteArray:(NSInteger)fatherId;

@end
