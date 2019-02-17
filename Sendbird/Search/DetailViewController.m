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

@interface DetailViewController ()
@property (nonatomic) DetailBook* selectedBook;
@property (nonatomic) NSMutableArray* bookmarkArr;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"Book Detail";
   self.bookmarkArr = [[NSMutableArray alloc]init];
  self.navigationController.navigationBar.prefersLargeTitles = NO;
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
        
        
          if(!self.selectedBook.like){
            [self.likeBtn setTitle:@"click like" forState:UIControlStateNormal];
            [self.likeBtn addTarget:self action:@selector(askAddFavoriteArr:) forControlEvents: UIControlEventTouchUpInside];
          }else{
              [self.likeBtn setTitle:@"liked" forState:UIControlStateNormal];
            [self.likeBtn addTarget:self action:@selector(askRemoveFavoriteArr:) forControlEvents: UIControlEventTouchUpInside];
          }
       
        self.languageLb.text = self.selectedBook.language;
        self.yearLb.text = self.selectedBook.year;
        self.ratingLb.text = self.selectedBook.rating;
            self.isbn10Lb.text = self.selectedBook.isbn10;
        self.textView.text = self.selectedBook.desc;
//        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self.selectedBook.url];
//        [attributedString addAttribute: NSLinkAttributeName value:self.selectedBook.url range: NSMakeRange(0, str.length)];
//        textView.attributedText = attributedString;
        self.urlLb.text = self.selectedBook.url;
       //  [self.urlLb setTextColor:[UIColor blueColor]];
        //TODO: make hyperlink
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:file.URL_ADDRESS]];
        
        
        NSString *encodeUrl = [self.selectedBook.image stringByRemovingPercentEncoding];
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
- (void)fetchBookDetail:(NSString*)urlString withISBN:(NSString*)ISBN callback:(void (^)(NSError *error, BOOL success))callback
{
  
  __block NSMutableDictionary *tempolaryArr;
  NSString* finalUrl = [NSString stringWithFormat:@"%@/%@", urlString, ISBN];
  NSURL* url = [NSURL URLWithString:finalUrl];
  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
  [request setHTTPMethod:@"GET"];
  [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  //   [request setValue:[NSString stringWithFormat:@"%d",[jsonData length]] forHTTPHeaderField:@"Content-length"];
  
  //  NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
  //  [marksDict setObject:"keyword" forKey:""];
  //  NSData* jsonData = [NSJSONSerialization dataWithJSONObject:userDictionary options:NSJSONWritingPrettyPrinted error: &error];
  //  [request setHTTPBody:jsonData];//set data
  
  
  
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
#pragma mark - Action for delegate

- (void)askAddFavoriteArr:(id)sender
{
//  RLMResults<RMdetailBook *> *books = [RMdetailBook objectsWhere:@"isbn13 = %@", self.selectedBook.isbn13];
//
//  NSMutableArray *array = [NSMutableArray new];
//  for (RLMObject *object in books) {
//    [array addObject:object];
//  }

    RMdetailBook *newBook =  [RMdetailBook objectWithDetailBook:self.selectedBook withComment:@""];
    newBook.like = YES;
    // Get the default Realm
    RLMRealm *realm = [RLMRealm defaultRealm];
    // Add to Realm with transaction
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:newBook];
    [realm commitWriteTransaction];
 

 
}

- (void)askRemoveFavoriteArr:(id)sender
{
//  if ([self.delegate respondsToSelector:@selector(removeFavoriteArr:withObject:)]) {
  RMdetailBook *newBook =  [RMdetailBook objectWithDetailBook:self.selectedBook withComment:@""];
  newBook.like = NO;
  // Get the default Realm
  RLMRealm *realm = [RLMRealm defaultRealm];
  // Add to Realm with transaction
  [realm beginWriteTransaction];
  [realm addOrUpdateObject:newBook];
  [realm commitWriteTransaction];
    
 // }
  
  
}
@end
