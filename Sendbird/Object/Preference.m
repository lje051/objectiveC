//
//  Preference.m
//  Sendbird
//
//  Created by Jeeeun Lim on 14/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//

#import "Preference.h"


#define jeefavoriteArr            @"favoriteArr"
#define jeehistoryArr            @"historyArr"
@implementation Preference
@synthesize favoriteArr;
@synthesize historyArr;

//TODO: synthesize 뭐하는것?!
- (NSMutableArray *)favoriteArr
{
  NSString *jsonString = [[NSUserDefaults standardUserDefaults] stringForKey:jeefavoriteArr];
  if (nil != jsonString) {
    favoriteArr = [jeeUtil convertArray2JsonStr:jsonString];
  } else {
    favoriteArr = [[NSMutableDictionary alloc] init];
  }
  return favoriteArr;
}

- (void)setFavoriteArr:(NSMutableArray *)newValue
{
  NSString *jsonString = [jeeUtil convertArray2JsonStr:newValue];
  [[NSUserDefaults standardUserDefaults]setObject:jsonString forKey:jeefavoriteArr];
  [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
