//
//  SearchViewController.m
//  Sendbird
//
//  Created by Jeeeun Lim on 12/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//
#import "Book.h"
#import "SearchViewController.h"
#import "DetailViewController.h"

@interface SearchViewController ()<UICollectionViewDelegate
,UICollectionViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *bookSearchbar;
@property (nonatomic) NSMutableArray* searchResultArr;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPages;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  [self.navigationController setNavigationBarHidden:NO];
  self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screenRect.size.width;
  self.searchResultArr = [[NSMutableArray alloc]init];
  UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
  [flowLayout setItemSize:CGSizeMake(screenWidth -10, 100.0f)];
  [flowLayout setMinimumInteritemSpacing:1.0f];
  [flowLayout setMinimumLineSpacing:1.0f];
  [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
  self.bookSearchbar.delegate = self;
  [self.collectionView setCollectionViewLayout:flowLayout];
  _currentPage = 0;
  [self fetchBookSearchList:@"https://api.itbook.store/1.0/search" withKeyword:@"korea"  callback:^(NSError *error, BOOL success) {
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
  
  //  BOOL rendered =  [self PostJson];
  //  if(rendered){
  //    self.collectionView.delegate = self;
  //    self.collectionView.dataSource = self;
  //    [self.collectionView reloadData];
  //  }else{
  //    NSLog(@"not yet");
  //  }
  //
  
  // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
  self.navigationController.navigationBar.prefersLargeTitles = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
   // [self.navigationController setNavigationBarHidden:YES];
}


- (void)fetchBookSearchList:(NSString*)urlString withKeyword:(NSString*)keyword callback:(void (^)(NSError *error, BOOL success))callback
{
  
  __block NSMutableDictionary *tempolaryArr;
  NSString* finalUrl = [NSString stringWithFormat:@"%@/%@", urlString, keyword];
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
      int totalNum = [[jsonDict objectForKey:@"total"] integerValue];
    
    if( totalNum >10){
      self.totalPages = (totalNum/10) + 1;
      
    }else{
      self.totalPages = 1;
      
    }
    
    
    
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
        
        self.searchResultArr = arr;
        
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
  
  return [self.searchResultArr count];
  
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  // Book * book = [self.bookArr objectAtIndex:indexPath.row];
  
  Book *selectedBook = [self.searchResultArr objectAtIndex:indexPath.row];
  
  //  self.ndx = history.APPR_NDX;
  DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
  vc.isbn13 = selectedBook.isbn13;
  [self.navigationController pushViewController:vc animated:YES];
  
  
  
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  
  UICollectionViewCell *cell =(UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"myCellData1" forIndexPath:indexPath];
  Book * book = [self.searchResultArr objectAtIndex:indexPath.row];
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
  
  NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: encodeUrl]];
  imgView.image = [UIImage imageWithData: imageData];
  
  
  return cell;
  
  
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1;
}


#pragma mark - UISearchBarDelegate


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
  [self fetchBookSearchList:@"https://api.itbook.store/1.0/search" withKeyword:searchBar.text  callback:^(NSError *error, BOOL success) {
    if (success) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        // Your UI update code here
      });
      
    }
    else {
      NSLog(@"%@", error);
    }
  }];
   [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
   [searchBar resignFirstResponder];
}
@end
