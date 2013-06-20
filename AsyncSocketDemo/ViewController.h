//
//  ViewController.h
//  AsyncSocketDemo
//
//  Created by Wingle Wong on 6/19/13.
//  Copyright (c) 2013 Wingle Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UITextField *hostTextField;
@property (strong, nonatomic) IBOutlet UITextField *portTextField;
@property (strong, nonatomic) IBOutlet UIButton *swithBtn;
@property (strong, nonatomic) IBOutlet UITextView *incomeMessageTextView;
@property (strong, nonatomic) IBOutlet UITextField *sendMsgTextField;
- (IBAction)swithBtnClicked:(id)sender;
- (IBAction)sendMessage:(id)sender;


@end
