//
//  TabbarViewController.m
//  Sendbird
//
//  Created by Jeeeun Lim on 15/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//

#import "TabbarViewController.h"
#import "Preference.h"
@interface TabbarViewController ()

@end

@implementation TabbarViewController
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
    
     // [jeeUtil addObserver:self selector:@selector(onCommand:) message:@""];
    // Do any additional setup after loading the view.
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//  BookmarkViewController* vc =   [[self viewControllers] objectAtIndex:2];
//  [jeeUtil addObserver:vc selector:@selector(onCommand:) message:@""];
  NSLog(@"%@", item.title);
}

- (void)tabBar:(UITabBar *)tabBar didBeginCustomizingItems:(NSArray<UITabBarItem *> *)items{
  
  NSLog(@"%@", items);
}

//-(void)addFavoriteArr:(DetailBook *)selectedBook{
//  NSArray *viewControllers = [self.tabBarController viewControllers];
//  BookmarkViewController *listView = (BookmarkViewController *)viewControllers[1];
// 
//
//
//
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
