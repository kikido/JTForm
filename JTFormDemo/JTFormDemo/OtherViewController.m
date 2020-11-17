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
    [formDescriptor addSection:section];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeSwitch rowType:JTFormRowTypeSwitch title:@"JTFormRowTypeSwitch"];
    row.value = @YES;
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeSwitch rowType:JTFormRowTypeSwitch title:@"JTFormRowTypeSwitchJTFormRowTypeSwitchJTFormRowTypeSwitch"];
    row.imageUrl = netImageUrl(130, 30);
    row.required = YES;
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeCheck rowType:JTFormRowTypeCheck title:@"JTFormRowTypeCheck"];
    row.value = @YES;
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeCheck rowType:JTFormRowTypeCheck title:@"JTFormRowTypeCheckJTFormRowTypeCheckJTFormRowTypeCheckJTFormRowTypeCheck"];
    row.imageUrl = netImageUrl(30, 30);
    row.required = YES;
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeStepCounter rowType:JTFormRowTypeStepCounter title:@"JTFormRowTypeStepCounter"];
    row.value = @50;
    [row.configAfterUpdate setObject:@YES forKey:@"stepControl.wraps"];
    [row.configAfterUpdate setObject:@10 forKey:@"stepControl.stepValue"];
    [row.configAfterConfig setObject:@10 forKey:@"minimumValue"];
    [row.configAfterConfig setObject:@100 forKey:@"maximumValue"];
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeStepCounter rowType:JTFormRowTypeStepCounter title:@"JTFormRowTypeStepCounterJTFormRowTypeStepCounterJTFormRowTypeStepCounterJTFormRowTypeStepCounter"];
    row.required = YES;
    row.imageUrl = netImageUrl(30, 30);
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeSegmentedControl rowType:JTFormRowTypeSegmentedControl title:@"JTFormRowTypeSegmentedControl"];
    row.selectorOptions = [JTOptionObject optionObjectsWithOptionValues:@[@1, @2, @3] optionTexts:@[@"早上", @"中午", @"晚上"]];
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeSegmentedControl rowType:JTFormRowTypeSegmentedControl title:@"JTFormRowTypeSegmentedControl"];
    row.selectorOptions = [JTOptionObject optionObjectsWithOptionValues:@[@1, @2, @3] optionTexts:@[@"早上", @"中午", @"晚上"]];
    row.value = [JTOptionObject optionsObjectWithOptionValue:@1 optionText:@"早上"];
    row.required = YES;
    row.imageUrl = netImageUrl(30, 30);
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeSlider rowType:JTFormRowTypeSlider title:@"JTFormRowTypeSlider"];
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeSlider rowType:JTFormRowTypeSlider title:@"JTFormRowTypeSliderJTFormRowTypeSliderJTFormRowTypeSliderJTFormRowTypeSlider"];
    row.value = @(30.);
    [row.configAfterConfig setObject:@(100.) forKey:@"maximumValue"];
    [row.configAfterConfig setObject:@(10.) forKey:@"minimumValue"];
    [row.configAfterUpdate setObject:@(4) forKey:@"steps"];
    row.required = YES;
    row.imageUrl = netImageUrl(30, 30);
    [section addRow:row];
    
    JTForm *form = [[JTForm alloc] initWithDescriptor:formDescriptor];
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
