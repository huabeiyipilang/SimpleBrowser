//
//  QuickUrlDAO.h
//  SimpleBrowser
//
//  Created by Carl Li on 14-8-13.
//  Copyright (c) 2014年 Carl Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuickUrl.h"

@interface QuickUrlDAO : NSObject
- (void) initDAO;
- (NSString*) getFilePath;
- (int) add:(QuickUrl*)quickUrl;
- (int) remove:(QuickUrl*)quickUrl;
@end
