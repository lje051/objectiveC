//
//  jeeUtil.m
//  Sendbird
//
//  Created by Jeeeun Lim on 14/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//

#import "jeeUtil.h"

@implementation jeeUtil

+ (void)writeDataToFile:(NSString *)fileName withData:(NSData *)data
{
  NSString *path = [jeeUtil documentPath:fileName];
  
  // 폴더가 없다면 폴더 생성.
  if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
  }
  
  [data writeToFile:path atomically:YES];
}
+ (NSString *)documentPath:(NSString *)fname {
  return [[jeeUtil documentDir] stringByAppendingPathComponent:fname];
}

+ (NSString *)documentDir {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  return [paths objectAtIndex:0];
}
//array를 json string으로 컨버팅
+ (NSString *)convertArray2JsonStr:(NSMutableArray *)arr
{
  NSError *error;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:0 error:&error];
  NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  //NSLog(@"%@", jsonString);
  //[[NSUserDefaults standardUserDefaults] setObject:jsonString forKey:PageEmailKey];// 저장.
  return jsonString;
}

// json string을 array으로 컨버팅
+ (NSMutableArray *)convertJsonStr2Array:(NSString *)jsonString
{
  //NSString *jsonString = [[NSUserDefaults standardUserDefaults] stringForKey:PageEmailKey];// 로딩.
  NSError *error;
  NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
  NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
  return arr;
}
+ (void)addObserver:(id)observer selector:(SEL)sel message:(NSString *)msg
{
  [[NSNotificationCenter defaultCenter] addObserver:observer selector:sel name:msg object:nil];
}

+ (void)removeObserver:(id)observer message:(NSString *)msg
{
  [[NSNotificationCenter defaultCenter] removeObserver:observer name:msg object:nil];
}


//
// postMessage
//
+ (void)postMessage:(id)sender message:(NSString *)aName msgID:(UInt16)msgID
{
  NSLog(@"\n-----------------------------------------------\n\
        TUtil::postMessage(3) \naName:%@ \nmsgID:%d\
        \n-----------------------------------------------\n", aName, msgID);
  
  NSString *theMsg = [NSString stringWithFormat:@"%d", msgID];
  NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:theMsg, @"msgID", nil];
  if(dictionary) {
    NSNotification *notification = [NSNotification notificationWithName:aName object:sender userInfo:dictionary];
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
  }
}

+ (void)postMessage:(id)sender message:(NSString *)aName msgID:(UInt16)msgID param1:(id)param1
{
  NSLog(@"\n-----------------------------------------------\n\
        TUtil::postMessage(4) \naName:%@ \nmsgID:%d \nparam1:%@\
        \n-----------------------------------------------\n", aName, msgID, param1);
  
  NSString *theMsg = [NSString stringWithFormat:@"%d", msgID];
  NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:theMsg, @"msgID", param1, @"param1", nil];
  if(dictionary) {
    NSNotification *notification = [NSNotification notificationWithName:aName object:sender userInfo:dictionary];
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
  }
}

+ (void)postMessage:(id)sender message:(NSString *)aName msgID:(UInt16)msgID param1:(id)param1 param2:(id)param2
{
  NSLog(@"\n-----------------------------------------------\n\
        TUtil::postMessage(5) \naName:%@ \nmsgID:%d \nparam1:%@ \nparam2:%@\
        \n-----------------------------------------------\n", aName, msgID, param1, param2);
  
  NSString *theMsg = [NSString stringWithFormat:@"%d", msgID];
  NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:theMsg, @"msgID", param1, @"param1", param2, @"param2", nil];
  if(dictionary) {
    NSNotification *notification = [NSNotification notificationWithName:aName object:sender userInfo:dictionary];
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
  }
}

+ (void)postMessage:(id)sender message:(NSString *)aName msgID:(UInt16)msgID param1:(id)param1 param2:(id)param2 param3:(id)param3
{
  NSLog(@"\n-----------------------------------------------\n\
        TUtil::postMessage(6) \naName:%@ \nmsgID:%d \nparam1:%@ \nparam2:%@ \nparam3:%@\
        \n-----------------------------------------------\n", aName, msgID, param1, param2, param3);
  
  NSString *theMsg = [NSString stringWithFormat:@"%d", msgID];
  NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:theMsg, @"msgID",
                              param1, @"param1",
                              param2, @"param2",
                              param3, @"param3",
                              nil];
  if(dictionary) {
    NSNotification *notification = [NSNotification notificationWithName:aName object:sender userInfo:dictionary];
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
  }
}

+ (BOOL) isNullOrEmpty:(NSString*)aStr {
  if(nil == aStr) {
    return YES;
  }
  if ([@"" isEqualToString:aStr]) {
    return YES;
  }
  
  return NO;
}

@end
