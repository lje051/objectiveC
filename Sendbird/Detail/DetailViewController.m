//
//  DetailViewController.m
//  Sendbird
//
//  Created by Jeeeun Lim on 14/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import "UIView+WebCacheOperation.h"
#import "DetailViewController.h"
#import <Realm/Realm.h>
#import "MemoView.h"

@interface DetailViewController ()<MemoViewDelegate>
@property (nonatomic) DetailBook* selectedBook;
@property (nonatomic) NSMutableArray* bookmarkArr;
@end

@implementation DetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Book Detail";
  self.bookmarkArr = [[NSMutableArray alloc]init];
  self.navigationController.navigationBar.prefersLargeTitles = NO;
  //make a popup item
  UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithTitle:@"Note"               style:UIBarButtonItemStylePlain target:self action:@selector(startMemo:)];
  self.navigationItem.rightBarButtonItem = refreshItem;
  [self fetchBookDetail:@"https://api.itbook.store/1.0/books" withISBN:self.isbn13 callback:^(NSError *error, BOOL success) {
    if (success) {
      dispatch_async(dispatch_get_main_queue(), ^{
        
        
        self.titleLb.text = self.selectedBook.title;
        self.priceLb.text = self.selectedBook.price;
        self.subTitleLb.text = self.selectedBook.subtitle;
        self.isbnLb.text = self.selectedBook.isbn13;
        self.authorLb.text = self.selectedBook.authors;
        self.publisherLb.text = self.selectedBook.publisher;
        self.pageLb.text = [NSString stringWithFormat:@"%@pages", self.selectedBook.pages];
        
        RMdetailBook *book = [[RMdetailBook objectsWhere:@"isbn13 = %@", self.selectedBook.isbn13] firstObject];
        
        
        if ([book.bookmark isEqualToString:@"YES"]){
          [self.likeBtn setTitle:@"liked" forState:UIControlStateNormal];
          [self.likeBtn addTarget:self action:@selector(askRemoveFavoriteArr:) forControlEvents: UIControlEventTouchUpInside];
        }else{
          
          [self.likeBtn setTitle:@"click like" forState:UIControlStateNormal];
          [self.likeBtn addTarget:self action:@selector(askAddFavoriteArr:) forControlEvents: UIControlEventTouchUpInside];
        }
        
        if ([jeeUtil isNullOrEmpty:book.comment]){
          
        }else{
          
          self.selectedBook.comment = book.comment;
        }
        
        self.languageLb.text = self.selectedBook.language;
        self.yearLb.text = self.selectedBook.year;
        self.ratingLb.text = self.selectedBook.rating;
        self.isbn10Lb.text = self.selectedBook.isbn10;
        self.textView.text = self.selectedBook.desc;
        //making hyperlink with urltext
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self.selectedBook.url];
        [attributedString addAttribute: NSLinkAttributeName value: self.selectedBook.url range: NSMakeRange(0, self.selectedBook.url.length)];
        self.urlTv.attributedText = attributedString;
        
        
        NSString *encodeUrl = [self.selectedBook.image stringByRemovingPercentEncoding];
        //adding data for history tab
        [self addHistory];
        
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:encodeUrl]
                        placeholderImage:nil
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 if (error) {
                                   NSLog(@"Error occured : %@", [error description]);
                                 }
                               }];
      });
      
    }
    else {
      NSLog(@"%@", error);
    }
  }];
}
-(void)addHistory{
  
  
  RLMResults<RMdetailBook *> *books = [RMdetailBook objectsWhere:@"isbn13 = %@", self.selectedBook.isbn13];
  
  NSMutableArray *array = [NSMutableArray new];
  for (RLMObject *object in books) {
    [array addObject:object];
  }
  if([array count] >0){
    
  }else{
    RMdetailBook *newBook =  [RMdetailBook objectWithDetailBook:self.selectedBook withComment:@""];
    // Get the default Realm
    RLMRealm *realm = [RLMRealm defaultRealm];
    // Add to Realm with transaction
    [realm beginWriteTransaction];
    [realm addObject:newBook];
    [realm commitWriteTransaction];
  }
  
  
  
  
  
  
}
//getting book detail info
- (void)fetchBookDetail:(NSString*)urlString withISBN:(NSString*)ISBN callback:(void (^)(NSError *error, BOOL success))callback
{
  NSString* finalUrl = [NSString stringWithFormat:@"%@/%@", urlString, ISBN];
  NSURL* url = [NSURL URLWithString:finalUrl];
  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
  [request setHTTPMethod:@"GET"];
  [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  
  
  
  NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
  [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSData * responseData = [requestReply dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSLog(@"resultsDictionary is %@",jsonDict);
    
    if (error == nil) {
      DetailBook * selectedBook = [DetailBook objectWithJSON:jsonDict];
      self.selectedBook = selectedBook;
      
      
      callback(nil, YES);
    }
    else {
      callback(error, NO);
    }
    
    
    NSLog(@"requestReply: %@", jsonDict);
  }] resume];
}
#pragma mark - boorkmark Action

- (void)askAddFavoriteArr:(id)sender
{
  
  RMdetailBook *newBook =  [RMdetailBook objectWithDetailBook:self.selectedBook withComment:@""];
  newBook.bookmark = @"YES";
  // Get the default Realm
  RLMRealm *realm = [RLMRealm defaultRealm];
  // Add to Realm with transaction
  [realm beginWriteTransaction];
  [realm addOrUpdateObject:newBook];
  [realm commitWriteTransaction];
  
  [self.likeBtn setTitle:@"liked" forState:UIControlStateNormal];
  [self.likeBtn addTarget:self action:@selector(askRemoveFavoriteArr:) forControlEvents: UIControlEventTouchUpInside];
  
  
}

- (void)askRemoveFavoriteArr:(id)sender
{
  //  if ([self.delegate respondsToSelector:@selector(removeFavoriteArr:withObject:)]) {
  RMdetailBook *newBook =  [RMdetailBook objectWithDetailBook:self.selectedBook withComment:@""];
  newBook.bookmark = @"NO";
  // Get the default Realm
  RLMRealm *realm = [RLMRealm defaultRealm];
  [realm beginWriteTransaction];
  [realm addOrUpdateObject:newBook];
  [realm commitWriteTransaction];
  
  [self.likeBtn setTitle:@"click like" forState:UIControlStateNormal];
  [self.likeBtn addTarget:self action:@selector(askAddFavoriteArr:) forControlEvents: UIControlEventTouchUpInside];
  
  
}
#pragma mark - memoview delegate
- (void)startMemo:(id)sender
{
  MemoView *alertVC = [[MemoView alloc] initWithNibName:@"MemoView" bundle:nil];
  RMdetailBook *book = [[RMdetailBook objectsWhere:@"isbn13 = %@", self.selectedBook.isbn13] firstObject];
  
  if ([jeeUtil isNullOrEmpty:book.comment]){
    
  }else{
    
    alertVC.previousComment  = book.comment;
  }
  
  alertVC.delegate = self;
  
  [self addChildViewController:alertVC];
  alertVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
  [self.view addSubview:alertVC.view];
  alertVC.view.alpha = 0;
  [alertVC didMoveToParentViewController:self];
  
  [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
    
    alertVC.view.alpha = 1;
  } completion:nil];
  
  
}

-(void)onTapNoForMemo:(UIButton *)sender{
  MemoView *alertVC = (MemoView *)sender;
  if (nil != alertVC) {
    [alertVC.view removeFromSuperview];
    [alertVC removeFromParentViewController];
    alertVC = nil;
  }
}

-(void)onTapYesForMemo:(UIButton *)sender withString:(NSString *)comment{
  NSLog(@"%@", comment);
  
  RLMRealm *realm = [RLMRealm defaultRealm];
  self.selectedBook.comment = comment;
  RMdetailBook *book = [[RMdetailBook objectsWhere:@"isbn13 = %@", self.selectedBook.isbn13] firstObject];
  
  [realm beginWriteTransaction];
  book.comment = comment;
  [realm addOrUpdateObject:book];
  // the book's `title` property will remain unchanged.
  [realm commitWriteTransaction];
  
  MemoView *alertVC = (MemoView *)sender;
  if (nil != alertVC) {
    [alertVC.view removeFromSuperview];
    [alertVC removeFromParentViewController];
    alertVC = nil;
  }
}

@end
