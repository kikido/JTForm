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
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    ASTextNode *textNode = [[ASTextNode alloc] init];
    textNode.attributedText = [NSAttributedString rightAttributedStringWithString:@"测试一席好" font:nil color:nil];
    textNode.frame = CGRectMake(15, 100, 300, 50);
    textNode.backgroundColor = [UIColor blueColor];
    
    [self.view addSubnode:textNode];
    // Do any additional setup after loading the view.
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
