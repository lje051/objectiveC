//
//  RMdetailBook.m
//  Sendbird
//
//  Created by Jeeeun Lim on 16/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//

#import "RMdetailBook.h"

@implementation RMdetailBook

- (id)init
{
  self = [super init];
  if(self) {
  }
  return self;
}

- (void)dealloc
{
  self.like = NO;
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
  self.comment = nil;
  
}

+ (RMdetailBook *)objectWithDetailBook:(DetailBook *)selectedbook withComment:(NSString *)comment {
   RMdetailBook *rmObj =  [[RMdetailBook alloc] init];
 // self = [super init];

    rmObj.like = NO;
    rmObj.title    = selectedbook.title;
    rmObj.price    = selectedbook.price;
  rmObj.subtitle    = selectedbook.subtitle;
    rmObj.image    = selectedbook.image;
    rmObj.url    = selectedbook.url;
    rmObj.isbn13  = selectedbook.isbn13;
    rmObj.authors    =selectedbook.authors;
    rmObj.isbn10    = selectedbook.isbn10;
    rmObj.pages    =selectedbook.pages;
    rmObj.year    = selectedbook.year;
    rmObj.rating    =selectedbook.rating;
    rmObj.desc  =   selectedbook.desc;
    rmObj.language    = selectedbook.language;
    rmObj.publisher    = selectedbook.publisher;
    rmObj.error    =selectedbook.error;
    rmObj.comment = comment;

  
  return rmObj;
}

+ (NSString *)primaryKey {
  return @"employeeId";
}

@end

