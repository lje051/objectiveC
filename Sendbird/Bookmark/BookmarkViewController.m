//
//  BookmarkViewController.m
//  Sendbird
//
//  Created by Jeeeun Lim on 12/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//
#import "DetailViewController.h"
#import "BookmarkViewController.h"
#import <Realm/Realm.h>
@interface BookmarkViewController ()

@end

@implementation BookmarkViewController
- (void)onCommand:(NSNotification *)notif
{
  UInt16 msgtype = [[[notif userInfo] objectForKey:@"msgID"] intValue];
  switch(msgtype)
  {
    case ID_ADD_FAVLIST:
    {
      //[self getMyTodoList];
      break;
    }
    case ID_REMOVE_FAVLIST:
    {
      //[self getMyTodoList];
      break;
    }
    default:
    {
      NSLog(@"PageProfile::onCommand() - msgtype:%d", msgtype);
      break;
    }
  }
}
- (void)viewDidLoad {
    [super viewDidLoad];
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screenRect.size.width;
  self.bookmarkArr = [[NSMutableArray alloc]init];
  
//RLMResults<RMdetailBook *> *books = [RMdetailBook objectsWhere:@"like == %@", [NSNumber numberWithBool:YES]];
  
  // RLMResults<RMdetailBook *> *books = [RMdetailBook allObjects];
  RLMResults<RMdetailBook *> *sortedbooks = [RMdetailBook objectsWhere:@"bookmark = 'YES'"];
 // NSPredicate *newPredicate =
//[NSPredicate predicateWithFormat:@"like == %@", [NSNumber numberWithBool:YES]];
 
  [self.segmentControl addTarget:self action:@selector(tappedSegmentControl) forControlEvents:UIControlEventValueChanged];

 // RLMResults<RMdetailBook *>  *books = [RMdetailBook objectsWithPredicate:newPredicate];
  NSMutableArray *array = [NSMutableArray new];
  for (RLMObject *object in sortedbooks) {
    [array addObject:object];
  }
  self.bookmarkArr = array;
 
 
 
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.tableView reloadData];
  
}


-(void)viewWillAppear:(BOOL)animated{
  self.navigationController.navigationBar.prefersLargeTitles = YES;
  RLMResults<RMdetailBook *> *sortedbooks = [RMdetailBook objectsWhere:@"bookmark = 'YES'"];
  // NSPredicate *newPredicate =
  //[NSPredicate predicateWithFormat:@"like == %@", [NSNumber numberWithBool:YES]];
  
  
  
  // RLMResults<RMdetailBook *>  *books = [RMdetailBook objectsWithPredicate:newPredicate];
  NSMutableArray *array = [NSMutableArray new];
  for (RLMObject *object in sortedbooks) {
    [array addObject:object];
  }
  self.bookmarkArr = array;
  [self.tableView reloadData];
//  
//  
//  // RLMResults<RMdetailBook *>  *books = [RMdetailBook objectsWithPredicate:newPredicate];
//  NSMutableArray *array = [NSMutableArray new];
//  for (RLMObject *object in books) {
//    [array addObject:object];
//  }
//  self.bookmarkArr = array;
  
}

- (void)tappedSegmentControl{
  switch(self.segmentControl.selectedSegmentIndex) {
    case 0:
      [self filteredArr:@"Title"];
      break;
    case 1:
      [self filteredArr:@"Author"];
      break;
    case 2:
      [self filteredArr:@"Price"];
      break;
    default:
      break;
  }
}


-(void)filteredArr:(NSString*)dataString{
  //  RLMResults<Employee *> *employees = [Employee allObjects];
  //  NSMutableArray *array = [NSMutableArray array];
  //  for (Employee *employee in employees) {
  //    [array addObject:employee];
  //  }
  //[self.tableArray removeAllObjects];
  if([dataString isEqual: @"Title"]){
    RLMResults<RMdetailBook *> *books = [ [RMdetailBook objectsWhere:@"bookmark = 'YES'"]
                                     sortedResultsUsingKeyPath:@"title" ascending:YES];
   
    NSMutableArray *array = [NSMutableArray new];
    for (RLMObject *object in books) {
      [array addObject:object];
    }
    self.bookmarkArr = array;
  }else if([dataString isEqual: @"Author"]){
    RLMResults<RMdetailBook *> *books = [ [RMdetailBook objectsWhere:@"bookmark = 'YES'"]
                                         sortedResultsUsingKeyPath:@"authors" ascending:YES];
    
    NSMutableArray *array = [NSMutableArray new];
    for (RLMObject *object in books) {
      [array addObject:object];
    }
    self.bookmarkArr = array;
  }else{
    RLMResults<RMdetailBook *> *books = [ [RMdetailBook objectsWhere:@"bookmark = 'YES'"]
                                         sortedResultsUsingKeyPath:@"price" ascending:YES];
    
    NSMutableArray *array = [NSMutableArray new];
    for (RLMObject *object in books) {
      [array addObject:object];
    }
    self.bookmarkArr = array;
  }
  
  [self.tableView reloadData];
  
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return  [self.bookmarkArr count];
  
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = nil;
  
  cell = [tableView dequeueReusableCellWithIdentifier:@"myCellData1"];
  if (nil ==cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"myCellData1"];
    
  }
  Book * book = [self.bookmarkArr objectAtIndex:indexPath.row];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  Book *selectedBook = [self.bookmarkArr objectAtIndex:indexPath.row];
  DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
  vc.isbn13 = selectedBook.isbn13;
  [self.navigationController pushViewController:vc animated:YES];
  
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  
  return 135;
}

@end
