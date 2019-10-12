//
//  ValidatorViewController.m
//  JTForm
//
//  Created by dqh on 2019/5/9.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "ValidatorViewController.h"
#import "JTIdCardValidator.h"
#import "JTFormRegexValidator.h"

@interface ValidatorViewController ()

@end

@implementation ValidatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JTFormDescriptor *formDescriptor = [JTFormDescriptor formDescriptor];
    formDescriptor.addAsteriskToRequiredRowsTitle = YES;
    JTSectionDescriptor *section = nil;
    JTRowDescriptor *row = nil;
    
#pragma mark - validator
    
    section = [JTSectionDescriptor formSection];
    [formDescriptor addSection:section];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeName rowType:JTFormRowTypeName title:@"姓名"];
    row.required = YES;
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeEmail rowType:JTFormRowTypeEmail title:@"验证邮箱"];
    [row addValidator:[JTFormRegexValidator formRegexValidatorWithMsg:@"邮箱格式错误" regex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,11}"]];
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypePassword rowType:JTFormRowTypePassword title:@"验证密码"];
    [row addValidator:[JTFormRegexValidator formRegexValidatorWithMsg:@"密码长度应在6~32位之间,且至少包含一个数字和字母" regex:@"(?=.*\\d)(?=.*[A-Za-z])^.{6,32}$"]];
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeInteger rowType:JTFormRowTypeInteger title:@"验证数字"];
    [row addValidator:[JTFormRegexValidator formRegexValidatorWithMsg:@"应大于等于50或者小于等于100" regex:@"^([5-9][0-9]|100)$"]];
    [section addRow:row];
    
    
    JTForm *form = [[JTForm alloc] initWithDescriptor:formDescriptor];
    form.frame = CGRectMake(0, 0, kJTScreenWidth, kJTScreenHeight-64.);
    [self.view addSubview:form];
    self.form = form;
    
    
    self.navigationItem.rightBarButtonItems = nil;
    UIButton *a = [UIButton buttonWithType:UIButtonTypeCustom];
    [a setTitle:@"验证" forState:UIControlStateNormal];
    [a setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [a addTarget:self action:@selector(validationAction) forControlEvents:UIControlEventTouchUpInside];
    [a sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:a];
    self.navigationItem.rightBarButtonItem = item;
    // Do any additional setup after loading the view.
}

- (void)validationAction
{
    NSArray *errors = [self.form formValidationErrors];
    if (errors.firstObject) {
        [self.form showFormValidationError:errors.firstObject];
        return;
    }
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
