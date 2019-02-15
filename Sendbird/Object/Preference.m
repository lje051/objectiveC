//
//  Preference.m
//  Sendbird
//
//  Created by Jeeeun Lim on 14/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//

#import "Preference.h"

static Preference *_pSingleton = nil;


#define jeefavoriteArr           @"favoriteArr"
#define jeehistoryArr            @"historyArr"
@implementation Preference
@synthesize favoriteArr;
@synthesize historyArr;
+ (Preference*)Instance
{
  @synchronized([Preference class]) {
    if(nil == _pSingleton) {
      _pSingleton = [[self alloc] init];
      if(_pSingleton)  {
      }
    }
  }
  return _pSingleton;
}

- (id)init
{
  if((self = [super init])){
    self.favoriteArr  = nil;
    self.historyArr    = nil;
   
  }
  
  return self;
}


//TODO: synthesize 뭐하는것?!
- (NSMutableArray *)favoriteArr
{
  NSString *dataPath = [jeeUtil documentPath:@"favoriteArr"];
  NSData *data=[[NSData alloc]initWithContentsOfFile:dataPath];
  if(nil !=data){
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    favoriteArr = [unarchiver decodeObjectForKey:@"favoriteArr"];
    [unarchiver finishDecoding];
  }else{
    favoriteArr = [[NSMutableArray alloc]init];
    
  }
  
  return favoriteArr;
  
}

- (void)setFavoriteArr:(NSMutableArray *)newValue
{
  NSString *dataPath = [jeeUtil documentPath:@"favoriteArr"];
  NSMutableData *data = [[NSMutableData alloc]init];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
  [archiver encodeObject:newValue forKey:@"favoriteArr"];
  [archiver finishEncoding];
  [data writeToFile:dataPath atomically:YES];
}
- (NSMutableArray *)historyArr
{
  NSString *dataPath = [jeeUtil documentPath:@"historyArr"];
  NSData *data=[[NSData alloc]initWithContentsOfFile:dataPath];
  if(nil !=data){
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    historyArr = [unarchiver decodeObjectForKey:@"historyArr"];
    [unarchiver finishDecoding];
  }else{
    historyArr = [[NSMutableArray alloc]init];
    
  }
  
  return historyArr;
}

- (void)setHistoryArr:(NSMutableArray *)newValue
{
  NSString *dataPath = [jeeUtil documentPath:@"historyArr"];
  NSMutableData *data = [[NSMutableData alloc]init];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
  [archiver encodeObject:newValue forKey:@"historyArr"];
  [archiver finishEncoding];
  [data writeToFile:dataPath atomically:YES];
}

@end
