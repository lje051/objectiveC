//
//  RMdetailBook.h
//  Sendbird
//
//  Created by Jeeeun Lim on 16/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//

#import <Realm/Realm.h>
#import <Foundation/Foundation.h>
#import "Book.h"
#import "DetailBook.h"

@interface RMdetailBook : RLMObject
@property NSString* bookmark;
@property NSString* history;
@property  NSString *comment;
@property  NSString *title;
@property  NSString *price;
@property  NSString *subtitle;
@property  NSString *image;
@property  NSString *url;
@property  NSString *isbn13;
@property  NSString *authors;
@property  NSString *isbn10;
@property  NSString *pages;
@property  NSString *year;
@property  NSString *rating;
@property  NSString *desc;
@property  NSString *language;
@property  NSString *publisher;
@property  NSString *error;
+ (NSArray *)indexedProperties;
+ (NSString *)primaryKey;
+ (RMdetailBook *)objectWithDetailBook:(DetailBook *)selectedbook withComment:(NSString *)comment;

@end

