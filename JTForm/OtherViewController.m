//
//  OtherViewController.m
//  JTForm
//
//  Created by dqh on 2019/5/7.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "OtherViewController.h"

@interface OtherViewController ()

@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JTFormDescriptor *formDescriptor = [JTFormDescriptor formDescriptor];
    formDescriptor.addAsteriskToRequiredRowsTitle = YES;
    JTSectionDescriptor *section = nil;
    JTRowDescriptor *row = nil;
    
    
#pragma mark - other
    
    section = [JTSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeSwitch rowType:JTFormRowTypeSwitch title:@"JTFormRowTypeSwitch"];
    row.value = @YES;
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeSwitch rowType:JTFormRowTypeSwitch title:@"JTFormRowTypeSwitchJTFormRowTypeSwitchJTFormRowTypeSwitch"];
    row.imageUrl = netImageUrl(30, 30);
    row.required = YES;
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeCheck rowType:JTFormRowTypeCheck title:@"JTFormRowTypeCheck"];
    row.value = @YES;
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeCheck rowType:JTFormRowTypeCheck title:@"JTFormRowTypeCheckJTFormRowTypeCheckJTFormRowTypeCheckJTFormRowTypeCheck"];
    row.imageUrl = netImageUrl(30, 30);
    row.required = YES;
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeStepCounter rowType:JTFormRowTypeStepCounter title:@"JTFormRowTypeStepCounter"];
    row.value = @50;
    [row.cellConfigAfterUpdate setObject:@YES forKey:@"stepControl.wraps"];
    [row.cellConfigAfterUpdate setObject:@10 forKey:@"stepControl.stepValue"];
    [row.cellConfigAfterUpdate setObject:@10 forKey:@"stepControl.minimumValue"];
    [row.cellConfigAfterUpdate setObject:@100 forKey:@"stepControl.maximumValue"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeStepCounter rowType:JTFormRowTypeStepCounter title:@"JTFormRowTypeStepCounterJTFormRowTypeStepCounterJTFormRowTypeStepCounterJTFormRowTypeStepCounter"];
    row.required = YES;
    row.imageUrl = netImageUrl(30, 30);
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeSegmentedControl rowType:JTFormRowTypeSegmentedControl title:@"JTFormRowTypeSegmentedControl"];
    row.selectorOptions = [JTOptionObject formOptionsObjectsWithValues:@[@1, @2, @3] displayTexts:@[@"早上", @"中午", @"晚上"]];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeSegmentedControl rowType:JTFormRowTypeSegmentedControl title:@"JTFormRowTypeSegmentedControl"];
    row.selectorOptions = [JTOptionObject formOptionsObjectsWithValues:@[@1, @2, @3] displayTexts:@[@"早上", @"中午", @"晚上"]];
    row.value = [JTOptionObject formOptionsObjectWithValue:@1 displayText:@"早上"];
    row.required = YES;
    row.imageUrl = netImageUrl(30, 30);
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeSlider rowType:JTFormRowTypeSlider title:@"JTFormRowTypeSlider"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeSlider rowType:JTFormRowTypeSlider title:@"JTFormRowTypeSliderJTFormRowTypeSliderJTFormRowTypeSliderJTFormRowTypeSlider"];
    row.value = @(30.);
    [row.cellConfigAtConfigure setObject:@(100.) forKey:@"maximumValue"];
    [row.cellConfigAtConfigure setObject:@(10.) forKey:@"minimumValue"];
    [row.cellConfigAfterUpdate setObject:@(4) forKey:@"steps"];
    row.required = YES;
    row.imageUrl = netImageUrl(30, 30);
    [section addFormRow:row];
    
    JTForm *form = [[JTForm alloc] initWithFormDescriptor:formDescriptor];
    form.frame = self.view.bounds;
    [self.view addSubview:form];
    self.form = form;
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
