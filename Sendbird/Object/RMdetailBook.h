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


@interface RMdetailBook : RLMObject
@property (assign, nonatomic) BOOL like;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSString *image;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *isbn13;
@property (nonatomic, retain) NSString *authors;
@property (nonatomic, retain) NSString *isbn10;
@property (nonatomic, retain) NSString *pages;
@property (nonatomic, retain) NSString *year;
@property (nonatomic, retain) NSString *rating;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSString *language;
@property (nonatomic, retain) NSString *publisher;
@property (nonatomic, retain) NSString *error;
+ (NSString *)primaryKey;
+ (RMdetailBook *)objectWithDetailBook:(DetailBook *)selectedbook withComment:(NSString *)comment;
@end

