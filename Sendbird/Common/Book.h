//
//  Book.h
//  Sendbird
//
//  Created by Jeeeun Lim on 13/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Book : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSString *image;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *isbn13;
+ (Book *)objectWithJSON:(NSDictionary *)dict;
@end


