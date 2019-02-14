//
//  DetailBook.h
//  Sendbird
//
//  Created by Jeeeun Lim on 14/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"


@interface DetailBook : Book

@property (nonatomic, retain) NSString *authors;
@property (nonatomic, retain) NSString *isbn10;
@property (nonatomic, retain) NSString *pages;
@property (nonatomic, retain) NSString *year;
@property (nonatomic, retain) NSString *rating;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSString *language;
@property (nonatomic, retain) NSString *publisher;
@property (nonatomic, retain) NSString *error;

+ (DetailBook *)objectWithJSON:(NSDictionary *)dict;
@end

