//
//  RootViewController.m
//  JTForm
//
//  Created by dqh on 2019/5/6.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UIButton *button01 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button01 setTitle:@"Disable" forState:UIControlStateNormal];
    [button01 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button01 addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
    button01.tag = 99;
    [button01 sizeToFit];
    UIBarButtonItem *item01 = [[UIBarButtonItem alloc] initWithCustomView:button01];
    self.navigationItem.rightBarButtonItems = @[item01];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.form.frame = self.view.bounds;
}

- (void)testAction:(UIButton *)sender
{
    if (sender.tag == 99) {
        self.form.formDescriptor.disabled = !self.form.formDescriptor.disabled;
        [self.form.tableNode reloadData];
        
        if (self.form.formDescriptor.disabled) {
            [sender setTitle:@"Enable" forState:UIControlStateNormal];
        } else {
            [sender setTitle:@"Disable" forState:UIControlStateNormal];
        }
    } else {
    }
}

- (void)dealloc
{
    NSLog(@"<%@ %p> dealloc", NSStringFromClass([self class]), &self);
}

NSURL* netImageUrl(NSInteger width, NSInteger height)
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://placekitten.com/g/%zd/%zd", width, height]];
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
