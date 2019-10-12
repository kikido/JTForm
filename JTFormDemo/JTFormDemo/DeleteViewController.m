//
//  DeleteViewController.m
//  JTForm
//
//  Created by dqh on 2019/5/9.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "DeleteViewController.h"

@interface DeleteViewController ()

@end

@implementation DeleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JTFormDescriptor *formDescriptor = [JTFormDescriptor formDescriptor];
    formDescriptor.addAsteriskToRequiredRowsTitle = YES;
    formDescriptor.disabled = true;
    JTSectionDescriptor *section = nil;
    JTRowDescriptor *row = nil;
    
#pragma mark - delete
    
    section = [JTSectionDescriptor formSection];
    section.sectionOptions |= JTFormSectionOptionCanDelete;
    [formDescriptor addSection:section];
    
    row = [JTRowDescriptor rowDescriptorWithTag:@"00" rowType:JTFormRowTypeName title:@"1"];
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:@"01" rowType:JTFormRowTypeName title:@"2"];
    [section addRow:row];

    row = [JTRowDescriptor rowDescriptorWithTag:@"02" rowType:JTFormRowTypeName title:@"3"];
    [section addRow:row];

    row = [JTRowDescriptor rowDescriptorWithTag:@"03" rowType:JTFormRowTypeName title:@"4"];
    [section addRow:row];

    row = [JTRowDescriptor rowDescriptorWithTag:@"04" rowType:JTFormRowTypeName title:@"5"];
    [section addRow:row];
    
    #pragma mark - common
    
    section = [JTSectionDescriptor formSection];
    [formDescriptor addSection:section];
    
    row = [JTRowDescriptor rowDescriptorWithTag:@"10" rowType:JTFormRowTypeName title:@"1"];
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:@"11" rowType:JTFormRowTypeName title:@"2"];
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:@"12" rowType:JTFormRowTypeName title:@"3"];
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:@"13" rowType:JTFormRowTypeName title:@"4"];
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:@"14" rowType:JTFormRowTypeName title:@"5"];
    [section addRow:row];

    
    JTForm *form = [[JTForm alloc] initWithDescriptor:formDescriptor];
    form.frame = CGRectMake(0, 0, kJTScreenWidth, kJTScreenHeight-64.);
    [self.view addSubview:form];
    self.form = form;
    
    
    self.navigationItem.rightBarButtonItems = @[];
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b setTitle:@"Edit" forState:UIControlStateNormal];
    [b setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [b sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:b];
    self.navigationItem.rightBarButtonItem = item;
    // Do any additional setup after loading the view.
}

- (void)editAction:(UIButton *)sender
{
    [self.form.tableNode.view setEditing:!self.form.tableNode.view.editing animated:YES];
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
