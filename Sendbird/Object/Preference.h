//
//  Preference.h
//  Sendbird
//
//  Created by Jeeeun Lim on 14/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"
#import "DetailBook.h"
#import "jeeUtil.h"

@interface Preference : NSObject
@property (nonatomic, retain) NSMutableArray *favoriteArr;
@property (nonatomic, retain) NSMutableArray *historyArr;
@end

