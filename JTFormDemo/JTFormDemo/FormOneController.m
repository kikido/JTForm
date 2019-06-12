//
//  FormOneController.m
//  JTFormDemo
//
//  Created by dqh on 2019/6/12.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "FormOneController.h"

@interface FormOneController ()

@end

@implementation FormOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JTFormDescriptor *formDescriptor = [JTFormDescriptor formDescriptor];
    formDescriptor.addAsteriskToRequiredRowsTitle = YES;
    JTSectionDescriptor *section = nil;
    JTRowDescriptor *row = nil;
    
        
    section = [JTSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:@"00" rowType:JTFormRowTypeInfo title:@"Name"];
    row.value = @"张三";
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:@"01" rowType:JTFormRowTypeSwitch title:@"JTFormRowTypeSwitch"];
    row.value = @YES;
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeSwitch rowType:JTFormRowTypeSwitch title:@"JTFormRowTypeSwitchJTFormRowTypeSwitchJTFormRowTypeSwitch"];
    row.imageUrl = netImageUrl(30, 30);
    row.required = YES;
    [section addFormRow:row];
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
