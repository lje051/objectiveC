//
//  jeeUtil.h
//  Sendbird
//
//  Created by Jeeeun Lim on 14/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface jeeUtil : NSObject

+ (NSString *)  documentDir;
+ (NSString *)  documentPath:(NSString*)fname;
+ (void) writeDataToFile:(NSString *)fileName withData:(NSData *)data;
+ (NSString *)convertArray2JsonStr:(NSMutableArray *)arr;
+ (NSMutableArray *)convertJsonStr2Array:(NSString *)jsonString;
// Observer
+ (void)addObserver:(id)observer selector:(SEL)sel message:(NSString *)msg;
+ (void)removeObserver:(id)observer message:(NSString *)msg;
// postMessage
+ (void)postMessage:(id)sender message:(NSString *)msgName msgID:(UInt16)msgID;
+ (void)postMessage:(id)sender message:(NSString *)msgName msgID:(UInt16)msgID param1:(id)param1;
+ (void)postMessage:(id)sender message:(NSString *)msgName msgID:(UInt16)msgID param1:(id)param1 param2:(id)param2;
@end


