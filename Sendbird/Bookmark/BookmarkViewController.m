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
 


 // RLMResults<RMdetailBook *>  *books = [RMdetailBook objectsWithPredicate:newPredicate];
  NSMutableArray *array = [NSMutableArray new];
  for (RLMObject *object in sortedbooks) {
    [array addObject:object];
  }
  self.bookmarkArr = array;
 
 
  //[jeeUtil addObserver:self selector:@selector(onCommand:) message:@""];
  UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
  [flowLayout setItemSize:CGSizeMake(screenWidth -10, 100.0f)];
  [flowLayout setMinimumInteritemSpacing:1.0f];
  [flowLayout setMinimumLineSpacing:1.0f];
  [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
  [self.collectionView setCollectionViewLayout:flowLayout];
 
  self.collectionView.delegate = self;
  self.collectionView.dataSource = self;
  [self.collectionView reloadData];
  
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
  [self.collectionView reloadData];
//  
//  
//  // RLMResults<RMdetailBook *>  *books = [RMdetailBook objectsWithPredicate:newPredicate];
//  NSMutableArray *array = [NSMutableArray new];
//  for (RLMObject *object in books) {
//    [array addObject:object];
//  }
//  self.bookmarkArr = array;
  
}



#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  
  return [self.bookmarkArr count];
  
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  // Book * book = [self.bookArr objectAtIndex:indexPath.row];
  Book *book = [self.bookmarkArr objectAtIndex:indexPath.row];
  
  //  self.ndx = history.APPR_NDX;
  DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
  vc.isbn13 = book.isbn13;
  [self.navigationController pushViewController:vc animated:YES];
  
  
  
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  
  UICollectionViewCell *cell =(UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"myCellData1" forIndexPath:indexPath];
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1;
}

#pragma mark - DetailView Delegate
//
//-(void)addFavoriteArr:(DetailBook *)selectedBook{
//
//  if([self.bookmarkArr count] > 0){
//    [self.bookmarkArr addObject:selectedBook];
//  }else{
//    self.bookmarkArr = [[NSMutableArray alloc]init];
//  }
//
//
//  [self.collectionView reloadData];
//}
//-(void)removeFavoriteArr:(DetailBook *)selectedBook{
//
//  if([self.bookmarkArr count] > 0){
//    for(DetailBook * book in self.bookmarkArr){
//      if ( [book.isbn13 isEqualToString:selectedBook.isbn13]){
//          [self.bookmarkArr removeObject:selectedBook];
//        break;
//      }
//      }
//    }
//
//
//
//  [self.collectionView reloadData];
//}


@end
