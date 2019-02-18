//
//  DetailViewController.h
//  Sendbird
//
//  Created by Jeeeun Lim on 14/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//
#import "BookmarkViewController.h"
#import "HistoryViewController.h"
#import "DetailBook.h"
#import <UIKit/UIKit.h>

@protocol DetailViewDelegate<NSObject>
@optional

- (void)removeFavoriteArr:(DetailBook *)selectedBook;
- (void)addFavoriteArr:(DetailBook *)selectedBook;
- (void)addHistoryArr:(DetailBook *)selectedBook;
@end


@interface DetailViewController : UIViewController
@property (nonatomic, retain) NSString *isbn13;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *isbnLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *pageLb;
@property (weak, nonatomic) IBOutlet UILabel *authorLb;
@property (weak, nonatomic) IBOutlet UILabel *publisherLb;
@property (weak, nonatomic) IBOutlet UILabel *languageLb;
@property (weak, nonatomic) IBOutlet UILabel *yearLb;
@property (weak, nonatomic) IBOutlet UILabel *ratingLb;
@property (weak, nonatomic) IBOutlet UILabel *isbn10Lb;
@property (weak, nonatomic) IBOutlet UITextView *urlTv;

@property (nonatomic, assign) id<DetailViewDelegate> delegate;

@end

