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
#import "UIImageView+WebCache.h"
#import "UIView+WebCacheOperation.h"

@interface SearchViewController ()<UITableViewDelegate
,UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *bookSearchbar;
@property (nonatomic) NSMutableArray* searchResultArr;
@property (nonatomic, assign) NSInteger totalItems;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPages;
@end

@implementation SearchViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationController setNavigationBarHidden:NO];
  self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  self.searchResultArr = [[NSMutableArray alloc]init];
  
  self.bookSearchbar.delegate = self;
  _currentPage = 0;
  [self fetchBookSearchList:@"https://api.itbook.store/1.0/search" withKeyword:@"korea"  callback:^(NSError *error, BOOL success) {
    if (success) {
      dispatch_async(dispatch_get_main_queue(), ^{
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView reloadData];
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
    self.totalItems = totalNum;
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

- (void)loadPhotos:(NSInteger)page withUrl:(NSString*)urlString withKeyword:(NSString*)keyword{
  
  
  NSString* apiURL = [NSString stringWithFormat:@"%@/%@/%ld", urlString, keyword, (long)page];
  __block NSMutableDictionary *tempolaryArr;
  NSURLSession *session = [NSURLSession sharedSession];
  [[session dataTaskWithURL:[NSURL URLWithString:apiURL]
          completionHandler:^(NSData *data,
                              NSURLResponse *response,
                              NSError *error) {
            
            if (!error) {
              
              NSError *jsonError = nil;
              NSMutableDictionary *jsonObject = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
              if([NSNull null] != [jsonObject objectForKey:@"books"])
              {
                tempolaryArr = [jsonObject objectForKey:@"books"];
                NSMutableArray *arr = nil;
                
                for(NSDictionary *dict in tempolaryArr) {
                  if(nil == arr) {
                    arr = [NSMutableArray array];
                  }
                  
                  [arr addObject:[Book objectWithJSON:dict]];
                  // [self getNoticeAttachInfo:[dict objectForKey:@"ATTACH_LIST"]];
                }
                
                
                
                [self.searchResultArr addObjectsFromArray:arr];
              }
              self.currentPage = [[jsonObject objectForKey:@"page"] integerValue];
              self.totalItems  = [[jsonObject objectForKey:@"total"] integerValue];
              self.totalPages = (self.totalItems/10) + 1;
              
              dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                
              });
            }
          }] resume];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.currentPage == self.totalPages
      || self.totalItems == self.searchResultArr.count) {
    return self.searchResultArr.count;
  }
  return self.searchResultArr.count + 1;
  
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == [self.searchResultArr count] - 1 ) {
    [self loadPhotos:++self.currentPage withUrl:@"https://api.itbook.store/1.0/search" withKeyword:self.bookSearchbar.text];
  }
}
// 영업지역 리스트 출력
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = nil;
  if (indexPath.row == [self.searchResultArr count]) {
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell" forIndexPath:indexPath];
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
    [activityIndicator startAnimating];
    
  } else {
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"myCellData1"];
    if (nil ==cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:@"myCellData1"];
      
    }
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
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:encodeUrl]
               placeholderImage:nil
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (error) {
                          NSLog(@"Error occured : %@", [error description]);
                        }
                      }];
  }
  
  
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat result = 0.0f;
  
  if (indexPath.row == [self.searchResultArr count]) {
    result = 25;
  }else{
    result = 120;
  }
  return result;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  Book *selectedBook = [self.searchResultArr objectAtIndex:indexPath.row];
  DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
  vc.isbn13 = selectedBook.isbn13;
  [self.navigationController pushViewController:vc animated:YES];
  
}



#pragma mark - UISearchBarDelegate


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
  [self fetchBookSearchList:@"https://api.itbook.store/1.0/search" withKeyword:searchBar.text  callback:^(NSError *error, BOOL success) {
    if (success) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
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
   [self.searchResultArr removeAllObjects];
  [searchBar resignFirstResponder];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
 
}
@end
