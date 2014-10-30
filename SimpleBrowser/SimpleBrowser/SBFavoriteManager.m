//
//  SBFavoriteManager.m
//  SimpleBrowser
//
//  Created by Carl Li on 14-10-16.
//  Copyright (c) 2014年 Carl Li. All rights reserved.
//

#import "SBFavoriteManager.h"
#import "SBFavoriteDAO.h"
#import "FavoriteUrl.h"

static SBFavoriteManager *sInstance;

@implementation SBFavoriteManager{
    SBFavoriteDAO *favoriteDAO;
}

+(SBFavoriteManager *) getInstance{
    if(!sInstance){
        sInstance = [[SBFavoriteManager alloc] init];
    }
    return sInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        favoriteDAO = [[SBFavoriteDAO alloc]init];
        [favoriteDAO initTable];
    }
    return self;
}


-(int) addFavoriteUrl:(NSString *)url title:(NSString *)title fatherId:(NSInteger)fatherId{
    FavoriteUrl *favoriteUrl = [[FavoriteUrl alloc] init];
    favoriteUrl.url = url;
    favoriteUrl.title = title;
    favoriteUrl.fatherId = fatherId;
    return [favoriteDAO addFavorite:favoriteUrl];
}

-(NSMutableArray *) getFavoriteArray:(NSInteger)fatherId{
    return [favoriteDAO getFavoriteListByFatherId:fatherId];
}

@end
