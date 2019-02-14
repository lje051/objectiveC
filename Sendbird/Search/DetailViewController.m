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
#import "DetailBook.h"
@interface DetailViewController ()
@property (nonatomic) DetailBook* selectedBook;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.title = @"Book Detail"; self.navigationController.navigationBar.prefersLargeTitles = NO;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
