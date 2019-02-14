//
//  DetailBook.m
//  Sendbird
//
//  Created by Jeeeun Lim on 14/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//

#import "DetailBook.h"

@implementation DetailBook

- (id)init
{
  self = [super init];
  if(self) {
  }
  return self;
}

- (void)dealloc
{
  self.authors     = nil;
  self.isbn10     = nil;
  self.pages     = nil;
  self.year     = nil;
  self.rating     = nil;
  self.desc   = nil;
  self.language     = nil;
  self.publisher     = nil;
  self.error   = nil;
  self.title     = nil;
  self.price     = nil;
  self.subtitle     = nil;
  self.image     = nil;
  self.url     = nil;
  self.isbn13   = nil;
  
}

+ (DetailBook *)objectWithJSON:(NSDictionary *)dict
{
  
  return [[DetailBook alloc] initWithJSON:dict];
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
    self.authors    = [dict objectForKey:@"authors"];
    self.isbn10    = [dict objectForKey:@"isbn10"];
    self.pages    = [dict objectForKey:@"pages"];
    self.year    = [dict objectForKey:@"year"];
    self.rating    = [dict objectForKey:@"rating"];
    self.desc  =    [dict objectForKey:@"desc"];
    self.language    = [dict objectForKey:@"language"];
    self.publisher    = [dict objectForKey:@"publisher"];
    self.error    = [dict objectForKey:@"error"];
  }
  
  return self;
}

@end

