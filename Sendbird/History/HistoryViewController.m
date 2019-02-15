//
//  HistoryViewController.m
//  Sendbird
//
//  Created by Jeeeun Lim on 12/02/2019.
//  Copyright © 2019 jeeeun. All rights reserved.
//
#import "DetailViewController.h"
#import "HistoryViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void)onCommand:(NSNotification *)notif
{
  UInt16 msgtype = [[[notif userInfo] objectForKey:@"msgID"] intValue];
  switch(msgtype)
  {
    case ID_ADD_HISTORYLIST:
    {
      [self reloadHistoryArr];
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
  [jeeUtil addObserver:self selector:@selector(onCommand:) message:@""];
    // Do any additional setup after loading the view.
}

-(void)reloadHistoryArr{
  
}

@end
