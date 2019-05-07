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
#import "TestViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *tempRows;
@end

@implementation ViewController

- (instancetype)init
{
    if (self = [super init]) {
        _tempRows = @[].mutableCopy;
//        [self addObserver:self forKeyPath:@"tempRows" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JTFormDescriptor *formDescriptor = [JTFormDescriptor formDescriptor];
    JTSectionDescriptor *section = nil;
    JTRowDescriptor *row = nil;
    
    section = [JTSectionDescriptor formSection];
    section.headerAttributedString = [NSAttributedString attributedStringWithString:@"adadadaadadadaadadadaadadadaadadadaadadadaadadadaadadadaadadadaadadadaadadadaadadadaadadadaadadada" font:nil color:nil firstWordColor:nil];
    section.headerHeight = 80.;
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
    
    row = [JTRowDescriptor formRowDescriptorWithTag:@"4" rowType:JTFormRowTypePushButton title:@"formater"];
    row.action.rowBlock = ^(JTRowDescriptor * _Nonnull sender) {
        TextViewController *vc = [[TextViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:@"5" rowType:JTFormRowTypePushButton title:@"测试一下"];
    row.action.rowBlock = ^(JTRowDescriptor * _Nonnull sender) {
        TestViewController *vc = [[TestViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [section addFormRow:row];
    
    
    #pragma mark - other
//    section = [JTSectionDescriptor formSection];
//    [formDescriptor addFormSection:section];
//
//    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeSlider rowType:JTFormRowTypeSlider title:@"JTFormRowTypeSliderJTFormRowTypeSliderJTFormRowTypeSliderJTFormRowTypeSlider"];
//    row.value = @50.;
//    [section addFormRow:row];
//
//    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeSegmentedControl rowType:JTFormRowTypeSegmentedControl title:@"JTFormRowTypeSegmentedControl"];
//    row.selectorOptions = [JTOptionObject formOptionsObjectsWithValues:@[@1, @2, @3] displayTexts:@[@"早饭", @"午饭", @"晚饭"]];
//    [section addFormRow:row];
//
//    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeStepCounter rowType:JTFormRowTypeStepCounter title:@"JTFormRowTypeStepCounterJTFormRowTypeStepCounterJTFormRowTypeStepCounterJTFormRowTypeStepCounterJTFormRowTypeStepCounterJTFormRowTypeStepCounterJTFormRowTypeStepCounterJTFormRowTypeStepCounterJTFormRowTypeStepCounter"];
//    row.value = @100.;
//    [section addFormRow:row];
//
//    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeCheck rowType:JTFormRowTypeCheck title:@"JTFormRowTypeSwitchJTFormRowTypeSwitchJTFormRowTypeSwitchJTFormRowTypeSwitchJTFormRowTypeSwitchJTFormRowTypeSwitch"];
//    row.value = @YES;
//    [section addFormRow:row];
//
//    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeSwitch rowType:JTFormRowTypeSwitch title:@"JTFormRowTypeSwitchJTFormRowTypeSwitchJTFormRowTypeSwitchJTFormRowTypeSwitchJTFormRowTypeSwitchJTFormRowTypeSwitch"];
//    row.value = @YES;
//    [section addFormRow:row];
//
//    #pragma mark - date
//
//    section = [JTSectionDescriptor formSection];
//    section.headerAttributedString = [NSAttributedString attributedStringWithString:@"adadadaadadadaadadadaadadadaadadadaadadadaadadadaadadadaadadadaadadadaadadadaadadadaadadadaadadada" font:nil color:nil firstWordColor:nil];
//    [formDescriptor addFormSection:section];
//
//    NSDate *now = [[NSDate alloc] init];
//
//    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeDate rowType:JTFormRowTypeDate title:@"JTFormRowTypeDate"];
//    row.value = now;
//    row.selectorTitle = @"测试";
//    [section addFormRow:row];
//
//    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeTime rowType:JTFormRowTypeTime title:@"JTFormRowTypeTime"];
//    row.value = now;
//    [section addFormRow:row];
//
//    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeDateTime rowType:JTFormRowTypeDateTime title:@"JTFormRowTypeDateTime"];
//    row.value = now;
//    [section addFormRow:row];
//
//    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeCountDownTimer rowType:JTFormRowTypeCountDownTimer title:@"JTFormRowTypeCountDownTimer"];
//    row.value = now;
//    [section addFormRow:row];
//
//    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeDateInline rowType:JTFormRowTypeDateInline title:@"JTFormRowTypeDateInline"];
//    row.value = now;
//    [section addFormRow:row];
//
//
//#pragma mark - select
//
//    section = [JTSectionDescriptor formSection];
//    [formDescriptor addFormSection:section];
//
//    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypePushSelect rowType:JTFormRowTypePushSelect title:@"JTFormRowTypePushSelect"];
//    row.selectorTitle = @"测试";
//    row.selectorOptions = [JTOptionObject formOptionsObjectsWithValues:@[@1, @2, @3, @4] displayTexts:@[@"测试1", @"测试2", @"测试3", @"测试4"]];
//    [section addFormRow:row];
//
//    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeMultipleSelect rowType:JTFormRowTypeMultipleSelect title:@"JTFormRowTypeMultipleSelect"];
//    row.selectorTitle = @"测试";
//    row.selectorOptions = [JTOptionObject formOptionsObjectsWithValues:@[@1, @2, @3, @4] displayTexts:@[@"测试1", @"测试2", @"测试3", @"测试4"]];
//    [section addFormRow:row];
//
//    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeSheetSelect rowType:JTFormRowTypeSheetSelect title:@"JTFormRowTypeSheetSelect"];
//    row.selectorTitle = @"测试";
//    row.selectorOptions = [JTOptionObject formOptionsObjectsWithValues:@[@1, @2, @3, @4] displayTexts:@[@"测试1", @"测试2", @"测试3", @"测试4"]];
//    [section addFormRow:row];
//
//    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeAlertSelect rowType:JTFormRowTypeAlertSelect title:@"JTFormRowTypeAlertSelect"];
//    row.selectorTitle = @"测试";
//    row.selectorOptions = [JTOptionObject formOptionsObjectsWithValues:@[@1, @2, @3, @4] displayTexts:@[@"测试1", @"测试2", @"测试3", @"测试4"]];
//    [section addFormRow:row];
//
//    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypePickerSelect rowType:JTFormRowTypePickerSelect title:@"hhhh"];
//    row.selectorTitle = @"测试";
//    row.selectorOptions = [JTOptionObject formOptionsObjectsWithValues:@[@1, @2, @3, @4] displayTexts:@[@"测试1", @"测试2", @"测试3", @"测试4"]];
//    [section addFormRow:row];
    
    JTForm *form = [[JTForm alloc] initWithFormDescriptor:formDescriptor];
    form.frame = self.view.bounds;
    [self.view addSubview:form];
    
    
    
//    [self test];
}

#pragma mark - test

- (void)test
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"添加了");
        [[self aa] addObjectsFromArray:@[@1, @2]];
//        [self.tempArray insertObject:@1 atIndex:0];
    });
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    NSLog(@"dddddddd-dddddddd-dddddddd");
//    NSLog(@"%@", change);
//}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    NSLog(@"dddddddd-dddddddd-dddddddd");
//}

- (void)addTempRows:(NSSet *)objects
{
}

- (NSMutableArray *)aa
{
    return  [self mutableArrayValueForKey:@"tempRows"];

}


@end
