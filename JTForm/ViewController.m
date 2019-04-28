//
//  ViewController.m
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "ViewController.h"
#import "JTForm.h"
#import "JTOptionObject.h"

#import "YYFPSLabel.h"

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
    
    
    #pragma mark - date
    
    section = [JTSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    
    
//    for (NSInteger i =0; i < 10; i++) {
//        row = [JTRowDescriptor formRowDescriptorWithTag:nil rowType:JTFormRowTypeDefault title:@"JTFormRowTypeDefault"];
//        row.value = @"hhhhhhhhhhhhh";
//        [section addFormRow:row];
//    }
    
    
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
    
    #pragma mark - text field
    
    section = [JTSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    
    
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeName rowType:JTFormRowTypeName title:@"name"];
    row.value = @"adadandandjaaaaaadadandandjaaaaaadadandandjaaaaaadadandandjaaaaaadadandandjaaaaaadadandandjaaaaaadadandandjaaaaaadadandandjaaaaaadadandandjaaaaaadadandandjaaaaaadadandandjaaaaaadadandandjaaaaa";
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeEmail rowType:JTFormRowTypeEmail title:@"email"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeNumber rowType:JTFormRowTypeNumber title:@"number"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeInteger rowType:JTFormRowTypeInteger title:@"integer"];
    row.valueFormatter = [NSByteCountFormatter new];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeDecimal rowType:JTFormRowTypeDecimal title:@"decimal"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypePassword rowType:JTFormRowTypePassword title:@"password"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypePhone rowType:JTFormRowTypePhone title:@"phone"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeName rowType:JTFormRowTypeName title:@"name"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeURL rowType:JTFormRowTypeURL title:@"url"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeTextView rowType:JTFormRowTypeTextView title:@"JTFormRowTypeTextView"];
    row.value = @"niadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnvniadadadadn";
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeInfo rowType:JTFormRowTypeInfo title:@"JTFormRowTypeInfo"];
    row.value = @"知识测试一下";
    [section addFormRow:row];

    
    JTForm *form = [[JTForm alloc] initWithFormDescriptor:formDescriptor];
    form.frame = self.view.bounds;
//    form.frame = CGRectMake(0, 0, 200, 500);
    [self.view addSubview:form];
    
    YYFPSLabel *fps = [[YYFPSLabel alloc] initWithFrame:CGRectMake(15, 100., 100, 40.)];
    [self.view addSubview:fps];
    
    [self test];
    // Do any additional setup after loading the view, typically from a nib.
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
