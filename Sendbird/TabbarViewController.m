//
//  TabbarViewController.m
//  Sendbird
//
//  Created by Jeeeun Lim on 15/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//

#import "TabbarViewController.h"
@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//  BookmarkViewController* vc =   [[self viewControllers] objectAtIndex:2];
//  [jeeUtil addObserver:vc selector:@selector(onCommand:) message:@""];
  NSLog(@"%@", item.title);
}

- (void)tabBar:(UITabBar *)tabBar didBeginCustomizingItems:(NSArray<UITabBarItem *> *)items{
  
  NSLog(@"%@", items);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
