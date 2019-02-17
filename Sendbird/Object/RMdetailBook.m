//
//  RMdetailBook.m
//  Sendbird
//
//  Created by Jeeeun Lim on 16/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//
#import <Realm/Realm.h>
#import "RMdetailBook.h"

@implementation RMdetailBook


+ (RMdetailBook *)objectWithDetailBook:(DetailBook *)selectedbook withComment:(NSString *)comment {
  
    RMdetailBook *rmObj =  [[RMdetailBook alloc] init];
    rmObj.bookmark = @"NO";
    rmObj.history = @"YES";
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
  return @"isbn13";
}
+ (NSArray *)indexedProperties {
  return @[@"price", @"bookmark", @"authors", @"title", @"history"];
}


@end

