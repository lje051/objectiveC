//
//  RejectMemoViewController.m
//  GSTexpense
//
//  Created by Jeeeun Lim on 20/11/2017.
//  Copyright © 2017 ASPN. All rights reserved.
//

#import "MemoView.h"


@interface MemoView()


@end

@implementation MemoView
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.requestDescTv.delegate = self;
  //   self.partNameLb.text = firstItem.PART_NAME;
  UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
  
  [tapBackground setNumberOfTapsRequired:1];
  [self.view addGestureRecognizer:tapBackground];
  UIToolbar *ViewForDoneButtonOnKeyboard = [[UIToolbar alloc] init];
  [ViewForDoneButtonOnKeyboard sizeToFit];
  UIBarButtonItem *btnDoneOnKeyboard = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                        style:UIBarButtonItemStyleBordered target:self
                                                                       action:@selector(dismissKeyboard:)];
  [ViewForDoneButtonOnKeyboard setItems:[NSArray arrayWithObjects:btnDoneOnKeyboard, nil]];
  
  self.requestDescTv.inputAccessoryView = ViewForDoneButtonOnKeyboard;
  if([jeeUtil isNullOrEmpty:self.previousComment]){
    [self.defaultMemolb setHidden:NO];
  }else{
    [self.defaultMemolb setHidden:YES];
    self.requestDescTv.text = self.previousComment;
  }
  
  // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
- (IBAction)onTapYes:(UIButton *)sender  {
  
  [self.delegate onTapYesForMemo:self withString:self.requestDescTv.text];
  
}
- (IBAction)onTapNo:(UIButton *)sender {
  [self.delegate onTapNoForMemo:self];
}



#pragma mark - keyboard Delegate

-(void) dismissKeyboard:(id)sender
{
  [self.view endEditing:YES];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
  //self.requestDescTv.textColor = [UIColor colorWithRed:0.31 green:0.37 blue:0.44 alpha:1.0];
  [self.defaultMemolb setHidden:YES];
  
}
-(void)textViewDidEndEditing:(UITextView *)textView{
  if([textView.text isEqualToString:@""]){
    [self.defaultMemolb setHidden:NO];
  }
}
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
  CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  
  [UIView animateWithDuration:0.3 animations:^{
    CGRect f = self.view.frame;
    f.origin.y = -keyboardSize.height/2;
    self.view.frame = f;
  }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
  [UIView animateWithDuration:0.3 animations:^{
    CGRect f = self.view.frame;
    f.origin.y = 0.0f;
    self.view.frame = f;
  }];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
