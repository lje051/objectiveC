//
//  BookmarkViewController.h
//  Sendbird
//
//  Created by Jeeeun Lim on 12/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import <Realm/Realm.h>
@interface BookmarkViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (nonatomic) NSMutableArray* bookmarkArr;

@end


