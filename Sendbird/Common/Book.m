//
//  Book.m
//  Sendbird
//
//  Created by Jeeeun Lim on 13/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//

#import "Book.h"

@implementation Book
{
}

- (id)init
{
  self = [super init];
  if(self) {
  }
  return self;
}

- (void)dealloc
{
  self.title     = nil;
  self.price     = nil;
  self.subtitle     = nil;
  self.image     = nil;
  self.url     = nil;
  self.isbn13   = nil;

}

+ (Book *)objectWithJSON:(NSDictionary *)dict
{
  return [[Book alloc] initWithJSON:dict];
}

- (id)initWithJSON:(NSDictionary *)dict
{
  self = [super init];
  if(self) {
    
    
    self.title    = [dict objectForKey:@"title"];
    self.price    = [dict objectForKey:@"price"];
    self.subtitle    = [dict objectForKey:@"subtitle"];
    self.image    = [dict objectForKey:@"image"];
    self.url    = [dict objectForKey:@"url"];
    self.isbn13  = [dict objectForKey:@"isbn13"];
    
  }
  
  return self;
}

@end
