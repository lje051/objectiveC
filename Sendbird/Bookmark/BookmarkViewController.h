//
//  BookmarkViewController.h
//  Sendbird
//
//  Created by Jeeeun Lim on 12/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface BookmarkViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSMutableArray* bookmarkArr;

@end


