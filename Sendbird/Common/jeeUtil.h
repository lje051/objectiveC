//
//  jeeUtil.h
//  Sendbird
//
//  Created by Jeeeun Lim on 14/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface jeeUtil : NSObject
+ (NSString *)convertArray2JsonStr:(NSMutableArray *)arr;
+ (NSMutableArray *)convertJsonStr2Array:(NSString *)jsonString;
@end


