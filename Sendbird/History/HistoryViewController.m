//
//  HistoryViewController.m
//  Sendbird
//
//  Created by Jeeeun Lim on 12/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//
#import "DetailViewController.h"
#import "HistoryViewController.h"
#import <Realm/Realm.h>
@interface HistoryViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.historyArr = [[NSMutableArray alloc]init];
  RLMResults<RMdetailBook *> *books = [RMdetailBook objectsWhere:@"history = 'YES'"];
  
  NSMutableArray *array = [NSMutableArray new];
  for (RLMObject *object in books) {
    [array addObject:object];
  }
  self.historyArr = array;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
 
  [self.tableView reloadData];
  
  
}
- (IBAction)onTapEdit:(UIBarButtonItem *)sender {
    BOOL isEditMode = [self.tableView isEditing];
    [self.tableView setEditing:!isEditMode animated:YES];
  
    [self.tableView reloadData];
  
   // [self requestBookmarkSeqModify];
}

-(void)viewWillAppear:(BOOL)animated{
  self.navigationController.navigationBar.prefersLargeTitles = YES;
   RLMResults<RMdetailBook *> *books = [RMdetailBook objectsWhere:@"history = 'YES'"];
  
  NSMutableArray *array = [NSMutableArray new];
  for (RLMObject *object in books) {
    [array addObject:object];
  }
  self.historyArr = array;
  [self.tableView reloadData];
}


#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return  [self.historyArr count];
  
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = nil;
  
    cell = [tableView dequeueReusableCellWithIdentifier:@"myCellData1"];
    if (nil ==cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:@"myCellData1"];
      
    }
    Book * book = [self.historyArr objectAtIndex:indexPath.row];
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
  Book *selectedBook = [self.historyArr objectAtIndex:indexPath.row];
  DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
  vc.isbn13 = selectedBook.isbn13;
  [self.navigationController pushViewController:vc animated:YES];
  
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
  return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"PageBookmark::commitEditingStyle");
  
  //Delete conversation
  if(editingStyle == UITableViewCellEditingStyleDelete)
  {
    
    RMdetailBook *newBook =  [self.historyArr objectAtIndex:indexPath.row];
    RLMRealm *realm = [RLMRealm defaultRealm];
    RMdetailBook *book = [[RMdetailBook objectsWhere:@"isbn13 = %@", newBook.isbn13] firstObject];

    [realm beginWriteTransaction];
    book.history = @"NO";
   [realm addOrUpdateObject:book];
    // the book's `title` property will remain unchanged.
    [realm commitWriteTransaction];
    
    [self.historyArr removeObjectAtIndex:indexPath.row];
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    //Deletes the row from the tableView.
  
  }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

  
  return 135;
}
- (NSIndexPath *) tableView: (UITableView *) tableView targetIndexPathForMoveFromRowAtIndexPath: (NSIndexPath *) sourceIndexPath toProposedIndexPath: (NSIndexPath *) proposedDestinationIndexPath {
  NSLog(@"PageBookmark::targetIndexPathForMoveFromRowAtIndexPath");
  return proposedDestinationIndexPath;
}

// Override to support conditional rearranging of the table view.
- (BOOL) tableView: (UITableView *) tableView canMoveRowAtIndexPath: (NSIndexPath *) indexPath {
  return YES;
}

@end
