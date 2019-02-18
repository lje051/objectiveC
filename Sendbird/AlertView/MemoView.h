//
//  RejectMemoViewController.h
//  GSTexpense
//
//  Created by Jeeeun Lim on 20/11/2017.
//  Copyright © 2017 ASPN. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MemoViewDelegate

-(void) onTapYesForMemo:(UIButton*)sender withString:(NSString*)comment;
-(void) onTapNoForMemo:(UIButton*)sender;
@end

@interface MemoView : UIViewController<UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *defaultMemolb;
@property (nonatomic) NSString *previousComment;
@property (weak, nonatomic) IBOutlet UITextView *requestDescTv;
@property (nonatomic, strong) id<MemoViewDelegate> delegate;

@end
