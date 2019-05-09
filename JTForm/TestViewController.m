//
//  TestViewController.m
//  JTForm
//
//  Created by dqh on 2019/5/6.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "TestViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "JTHelper.h"


@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    BOOL isValid = [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^([5-9][0-9]|100)$"] evaluateWithObject:@60];
//    NSLog(@"result:%d", isValid);

    // Do any additional setup after loading the view.
}

- (void)keyboardWillShow:(NSNotification *)NSNotification
{
    NSLog(@"[%@] %s", [self class], __func__);
    CGRect keybordEndFrame = [NSNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.view.transform = CGAffineTransformMakeTranslation(0, -200);
}

- (void)keyboardWillHide
{
    NSLog(@"[%@] %s", [self class], __func__);
}

- (void)keyboardDidHide
{
    NSLog(@"[%@] %s", [self class], __func__);
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
