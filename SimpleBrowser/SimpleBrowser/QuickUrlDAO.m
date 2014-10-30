//
//  QuickUrlDAO.m
//  SimpleBrowser
//
//  Created by Carl Li on 14-8-13.
//  Copyright (c) 2014年 Carl Li. All rights reserved.
//

#import "QuickUrlDAO.h"

@implementation QuickUrlDAO
- (void)initDAO{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* path = [self getFilePath];
    
    BOOL exists = [fileManager fileExistsAtPath:path];
    
    if(!exists){
        NSString* defaultPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"quick_urls.plist"];
        NSError* error;
        BOOL success = [fileManager copyItemAtPath:defaultPath toPath:path error:&error];
        if (!success) {
            NSLog(@"error create file");
        }
    }
}

- (NSString *)getFilePath{
    NSString* documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* path = [documentDir stringByAppendingPathComponent:@"quick_urls.plist"];
    
    return path;
}

- (int)add:(QuickUrl *)quickUrl{
    return 0;
}

- (int)remove:(QuickUrl *)quickUrl{
    return 0;
}

@end


