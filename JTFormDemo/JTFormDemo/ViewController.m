//
//  ViewController.m
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "ViewController.h"
#import "JTForm.h"

#import "TextViewController.h"
#import "SelectViewController.h"
#import "DateViewController.h"
#import "OtherViewController.h"
#import "ValidatorViewController.h"
#import "DeleteViewController.h"
#import "WeiBoViewController.h"
#import "IGViewController.h"

@interface ViewController ()
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    JTFormDescriptor *formDescriptor = [JTFormDescriptor formDescriptor];
    JTSectionDescriptor *section = nil;
    JTRowDescriptor *row = nil;
    
    section = [JTSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:@"0" rowType:JTFormRowTypePushButton title:@"text"];
    row.action.rowBlock = ^(JTRowDescriptor * _Nonnull sender) {
        TextViewController *vc = [[TextViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:@"1" rowType:JTFormRowTypePushButton title:@"select"];
    row.action.rowBlock = ^(JTRowDescriptor * _Nonnull sender) {
        SelectViewController *vc = [[SelectViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:@"2" rowType:JTFormRowTypePushButton title:@"date"];
    row.action.rowBlock = ^(JTRowDescriptor * _Nonnull sender) {
        DateViewController *vc = [[DateViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:@"3" rowType:JTFormRowTypePushButton title:@"other"];
    row.action.rowBlock = ^(JTRowDescriptor * _Nonnull sender) {
        OtherViewController *vc = [[OtherViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:@"4" rowType:JTFormRowTypePushButton title:@"validator"];
    row.action.rowBlock = ^(JTRowDescriptor * _Nonnull sender) {
        ValidatorViewController *vc = [[ValidatorViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:@"5" rowType:JTFormRowTypePushButton title:@"delete"];
    row.action.rowBlock = ^(JTRowDescriptor * _Nonnull sender) {
        DeleteViewController *vc = [[DeleteViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:@"6" rowType:JTFormRowTypePushButton title:@"ig"];
    row.action.rowBlock = ^(JTRowDescriptor * _Nonnull sender) {
        IGViewController *vc = [[IGViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [section addFormRow:row];
    
    
    JTForm *form = [[JTForm alloc] initWithFormDescriptor:formDescriptor];
    form.frame = self.view.bounds;
    [self.view addSubview:form];
}

@end
