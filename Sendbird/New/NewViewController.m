//
//  NewViewController.m
//  Sendbird
//
//  Created by Jeeeun Lim on 12/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//
#import "Book.h"
#import "NewViewController.h"
#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCacheOperation.h"

@interface NewViewController ()<UICollectionViewDelegate
,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSMutableArray* bookArr;
@end

@implementation NewViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screenRect.size.width;
  self.bookArr = [[NSMutableArray alloc]init];
  UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
  [flowLayout setItemSize:CGSizeMake(screenWidth -10, 135.0f)];
  [flowLayout setMinimumInteritemSpacing:1.0f];
  [flowLayout setMinimumLineSpacing:1.0f];
  [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
  [self.collectionView setCollectionViewLayout:flowLayout];
  
  [self fetchBooksList:@"https://api.itbook.store/1.0/new" callback:^(NSError *error, BOOL success) {
    if (success) {
      dispatch_async(dispatch_get_main_queue(), ^{
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView reloadData];
        // Your UI update code here
      });
      
    }
    else {
      NSLog(@"%@", error);
    }
  }];
  
}


-(void)viewWillAppear:(BOOL)animated{
  self.navigationController.navigationBar.prefersLargeTitles = YES;
}


//fetching booklist from news url
- (void)fetchBooksList:(NSString*)urlString callback:(void (^)(NSError *error, BOOL success))callback
{
  
  __block NSMutableDictionary *tempolaryArr;
  NSURL* url = [NSURL URLWithString:urlString];
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
      if([NSNull null] != [jsonDict objectForKey:@"books"])
      {
        tempolaryArr =[jsonDict objectForKey:@"books"];
        NSMutableArray *arr = nil;
        
        for(NSDictionary *dict in tempolaryArr) {
          if(nil == arr) {
            arr = [NSMutableArray array];
          }
          
          [arr addObject:[Book objectWithJSON:dict]];
          // [self getNoticeAttachInfo:[dict objectForKey:@"ATTACH_LIST"]];
        }
        
        self.bookArr = arr;
        
      }
      
      callback(nil, YES);
    }
    else {
      callback(error, NO);
    }
    
    
    NSLog(@"requestReply: %@", jsonDict);
  }] resume];
}
#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  
  return [self.bookArr count];
  
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  // Book * book = [self.bookArr objectAtIndex:indexPath.row];
  Book *book = [self.bookArr objectAtIndex:indexPath.row];
  
  //  self.ndx = history.APPR_NDX;
  DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
  // vc.delegate = self.navigationController;
  vc.isbn13 = book.isbn13;
  [self.navigationController pushViewController:vc animated:YES];
  
  
  
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  
  UICollectionViewCell *cell =(UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"myCellData1" forIndexPath:indexPath];
  Book * book = [self.bookArr objectAtIndex:indexPath.row];
  UIImageView *imgView = (UIImageView *)[cell viewWithTag:100];
  UILabel *titleLb = (UILabel *)[cell viewWithTag:200];
  UILabel *subtitleLb = (UILabel *)[cell viewWithTag:300];
  UILabel *isbn13Lb = (UILabel *)[cell viewWithTag:400];
  UILabel *priceLb = (UILabel *)[cell viewWithTag:500];
  
  titleLb.text = book.title;
  subtitleLb.text = book.subtitle;
  isbn13Lb.text = book.isbn13;
  priceLb.text = book.price;
  
  NSString *encodeUrl = [book.image stringByRemovingPercentEncoding]; 
  
  [imgView sd_setImageWithURL:[NSURL URLWithString:encodeUrl]
             placeholderImage:nil
                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                      if (error) {
                        NSLog(@"Error occured : %@", [error description]);
                      }
                    }];
  
  return cell;
  
  
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1;
}


@end
