//
//  jeeUtil.m
//  Sendbird
//
//  Created by Jeeeun Lim on 14/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//

#import "jeeUtil.h"

@implementation jeeUtil

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


@end
