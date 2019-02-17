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
@interface HistoryViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HistoryViewController

- (void)onCommand:(NSNotification *)notif
{
  UInt16 msgtype = [[[notif userInfo] objectForKey:@"msgID"] intValue];
  switch(msgtype)
  {
    case ID_ADD_HISTORYLIST:
    {
     // [self reloadHistoryArr];
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
    // self.delegate = self;
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screenRect.size.width;
  
  self.historyArr = [[NSMutableArray alloc]init];
  RLMResults<RMdetailBook *> *books = [RMdetailBook allObjects];
  
  NSMutableArray *array = [NSMutableArray new];
  for (RLMObject *object in books) {
    [array addObject:object];
  }
  self.historyArr = array;
  self.collectionView.delegate = self;
  self.collectionView.dataSource = self;
  UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
  [flowLayout setItemSize:CGSizeMake(screenWidth -10, 100.0f)];
  [flowLayout setMinimumInteritemSpacing:1.0f];
  [flowLayout setMinimumLineSpacing:1.0f];
  [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
  [self.collectionView setCollectionViewLayout:flowLayout];
  
  [self.collectionView reloadData];
  
  
}
//- (void) onTapEdit:(id)sender
//{
//  BOOL isEditMode = [self.tbvBookmarkList isEditing];
//  [self.tbvBookmarkList setEditing:!isEditMode animated:YES];
//  
//  [self.tbvBookmarkList reloadData];
//  
//  [self requestBookmarkSeqModify];
//}

-(void)viewWillAppear:(BOOL)animated{
  self.navigationController.navigationBar.prefersLargeTitles = YES;
  RLMResults<RMdetailBook *> *books = [RMdetailBook allObjects];
  
  NSMutableArray *array = [NSMutableArray new];
  for (RLMObject *object in books) {
    [array addObject:object];
  }
  self.historyArr = array;
  [self.collectionView reloadData];
}



#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  
  return [self.historyArr count];
  
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  // Book * book = [self.bookArr objectAtIndex:indexPath.row];
  RMdetailBook *book = [self.historyArr objectAtIndex:indexPath.row];
  
  //  self.ndx = history.APPR_NDX;
  DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
  vc.isbn13 = book.isbn13;
  [self.navigationController pushViewController:vc animated:YES];
  
  
  
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  
  UICollectionViewCell *cell =(UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"myCellData1" forIndexPath:indexPath];
  RMdetailBook * book = [self.historyArr objectAtIndex:indexPath.row];
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


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"PageBookmark::commitEditingStyle");
  
  //Delete conversation
  if(editingStyle == UITableViewCellEditingStyleDelete)
  {
    NSLog(@"쎌삭제!!!");
    
  
    RLMRealm *realm = RLMRealm.defaultRealm;
    [realm beginWriteTransaction];
    [realm deleteObject:[self.historyArr objectAtIndex:indexPath.row]];
    [realm commitWriteTransaction];
    
    
    
    //Deletes the row from the tableView.
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }
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
