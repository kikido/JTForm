//
//  JTForm_Tests.m
//  JTForm Tests
//
//  Created by dqh on 2020/9/28.
//  Copyright © 2020 dqh. All rights reserved.
//

#import <XCTest/XCTest.h>
//#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "JTHelper.h"
#import "JTForm.h"
#import "JTBaseCell.h"
#import "NSObject+JTAdd.h"
#import <KIF.h>
#import <UIApplication-KIFAdditions.h>
#import <KIFUITestActor_Private.h>

#define NumberOfSections 2
#define NumberOfRows 10
#define kArrayOfTypes (@[@"JTFormRowTypeText", @"JTFormRowTypeName", @"JTFormRowTypeEmail", @"JTFormRowTypeNumber", @"JTFormRowTypeInteger", @"JTFormRowTypeDecimal", @"JTFormRowTypePassword", @"JTFormRowTypePhone", @"JTFormRowTypeURL", @"JTFormRowTypeFloatText", @"JTFormRowTypeTextView", @"JTFormRowTypeInfo", @"JTFormRowTypePushSelect", @"JTFormRowTypeMultipleSelect", @"JTFormRowTypeSheetSelect", @"JTFormRowTypeAlertSelect", @"JTFormRowTypePickerSelect", @"JTFormRowTypePushButton", @"JTFormRowTypeDate", @"JTFormRowTypeTime", @"JTFormRowTypeDateTime", @"JTFormRowTypeCountDownTimer", @"JTFormRowTypeDateInline", @"JTFormRowTypeTimeInline", @"JTFormRowTypeDateTimeInline", @"JTFormRowTypeCountDownTimerInline", @"JTFormRowTypeSwitch", @"JTFormRowTypeCheck", @"JTFormRowTypeStepCounter", @"JTFormRowTypeSegmentedControl", @"JTFormRowTypeSlider"])

@interface JTForm_Tests : KIFTestCase <XCTWaiterDelegate>
@end

@implementation JTForm_Tests {
    JTForm *_form;
    JTFormDescriptor *_formDescriptor;
    JTSectionDescriptor *_section;
    JTRowDescriptor *_row;
}

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    _formDescriptor = [JTFormDescriptor formDescriptor];
    JTRowDescriptor *row;
    for (int i = 0; i < NumberOfSections; i++) {
        _section = [JTSectionDescriptor formSection];
        [_formDescriptor addSection:_section];
        
        NSMutableArray *rows = [NSMutableArray array];
        for (int j = 0; j < NumberOfRows; j++) {
            row = [JTRowDescriptor rowDescriptorWithTag:@(i).description rowType:JTFormRowTypeInfo title:@(i).description];
            row.value = @(i).description;
            [rows addObject:row];
        }
        [_section addRows:rows];
    }
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kJTScreenWidth, kJTScreenHeight)];
    UIViewController *vc = [[UIViewController alloc] init];
    window.rootViewController = vc;
    [window makeKeyAndVisible];
    
    JTForm *form = [JTForm formWithDescriptor:_formDescriptor];
    form.frame = window.bounds;
    [vc.view addSubview:form];
    _form = form;
}

- (void)tearDown {
    _form = nil;
    _formDescriptor = nil;
    _section = nil;
    _row = nil;
}


#pragma mark - 可以用的

- (void)testRowValueIsEmpty
{
    JTRowDescriptor *row = [JTRowDescriptor rowDescriptorWithTag:@"node" rowType:JTFormRowTypeInfo title:nil];
    row.value = @"";
    XCTAssertTrue([row rowValueIsEmpty]);
    
    row.value = nil;
    XCTAssertTrue([row rowValueIsEmpty]);

    row.value = [NSNull null];
    XCTAssertTrue([row rowValueIsEmpty]);

    row.value = @[];
    XCTAssertTrue([row rowValueIsEmpty]);

    row.value = @{};
    XCTAssertTrue([row rowValueIsEmpty]);
}



#pragma mark - remove

- (void)testSectionRemoveRow
{
    NSUInteger numberOfRows = 100;
    JTRowDescriptor *row;
    JTRowDescriptor *middleRow;
    for (int i = 0; i < numberOfRows; i++) {
        row = [JTRowDescriptor rowDescriptorWithTag:@(i).description rowType:JTFormRowTypeInfo title:@(i).description];
        row.value = @(i).description;
        [_section addRow:row];
        if (i == numberOfRows / 2) {
            middleRow = row;
        }
    }
    [_section removeRow:middleRow];
    [_section removeRows:@[middleRow]];
    
    NSUInteger indexA = [_section indexOfRow:row];
    NSIndexPath *indexB = [_formDescriptor indexPathForRowDescriptor:row];
    NSIndexPath *indexC = [_form indexPathForRow:row];
    XCTAssertTrue(indexA == numberOfRows-2);
    XCTAssertTrue(indexB.row == numberOfRows-2);
    XCTAssertTrue(indexC.row == numberOfRows-2);
}

- (void)testFormRemoveRow
{
    NSUInteger numberOfRows = 100;
    JTRowDescriptor *row;
    JTRowDescriptor *middleRow;
    for (int i = 0; i < numberOfRows; i++) {
        row = [JTRowDescriptor rowDescriptorWithTag:@(i).description rowType:JTFormRowTypeInfo title:@(i).description];
        row.value = @(i).description;
        [_form addRow:row];
        if (i == numberOfRows / 2) {
            middleRow = row;
        }
    }
    [_form removeRow:middleRow];
    [_form removeRows:@[middleRow]];
    
    NSUInteger indexA = [_section indexOfRow:row];
    NSIndexPath *indexB = [_formDescriptor indexPathForRowDescriptor:row];
    NSIndexPath *indexC = [_form indexPathForRow:row];
    XCTAssertTrue(indexA == numberOfRows-2);
    XCTAssertTrue(indexB.row == numberOfRows-2);
    XCTAssertTrue(indexC.row == numberOfRows-2);
}

- (void)testSectionRemoveRowAtIndex
{
    NSUInteger numberOfRows = 100;
    JTRowDescriptor *row;
    for (int i = 0; i < numberOfRows; i++) {
        row = [JTRowDescriptor rowDescriptorWithTag:@(i).description rowType:JTFormRowTypeInfo title:@(i).description];
        row.value = @(i).description;
        [_section addRow:row];
    }
    [_section removeRowAtIndex:numberOfRows/2];
    
    NSUInteger indexA = [_section indexOfRow:row];
    NSIndexPath *indexB = [_formDescriptor indexPathForRowDescriptor:row];
    NSIndexPath *indexC = [_form indexPathForRow:row];
    XCTAssertTrue(indexA == numberOfRows-2);
    XCTAssertTrue(indexB.row == numberOfRows-2);
    XCTAssertTrue(indexC.row == numberOfRows-2);
}

- (void)testFormRemoveRowAtIndexPath
{
    NSUInteger numberOfRows = 100;
    JTRowDescriptor *row;
    for (int i = 0; i < numberOfRows; i++) {
        row = [JTRowDescriptor rowDescriptorWithTag:@(i).description rowType:JTFormRowTypeInfo title:@(i).description];
        row.value = @(i).description;
        [_form addRow:row];
    }
    [_form removeRowAtIndexPath:[NSIndexPath indexPathForRow:numberOfRows/2 inSection:0]];
    
    NSUInteger indexA = [_section indexOfRow:row];
    NSIndexPath *indexB = [_formDescriptor indexPathForRowDescriptor:row];
    NSIndexPath *indexC = [_form indexPathForRow:row];
    XCTAssertTrue(indexA == numberOfRows-2);
    XCTAssertTrue(indexB.row == numberOfRows-2);
    XCTAssertTrue(indexC.row == numberOfRows-2);
}

- (void)testSectionRemoveRowByTag
{
    NSUInteger numberOfRows = 100;
    JTRowDescriptor *row;
    for (NSUInteger i = 0; i < numberOfRows; i++) {
        row = [JTRowDescriptor rowDescriptorWithTag:@(i) rowType:JTFormRowTypeInfo title:@(i).description];
        row.value = @(i).description;
        [_section addRow:row];
    }
    [_section removeRowByTag:@(numberOfRows/2)];
    
    NSUInteger indexA = [_section indexOfRow:row];
    NSIndexPath *indexB = [_formDescriptor indexPathForRowDescriptor:row];
    NSIndexPath *indexC = [_form indexPathForRow:row];
    XCTAssertTrue(indexA == numberOfRows-2);
    XCTAssertTrue(indexB.row == numberOfRows-2);
    XCTAssertTrue(indexC.row == numberOfRows-2);
}

- (void)testFormRemoveRowByTag
{
    NSUInteger numberOfRows = 100;
    JTRowDescriptor *row;
    for (int i = 0; i < numberOfRows; i++) {
        row = [JTRowDescriptor rowDescriptorWithTag:@(i) rowType:JTFormRowTypeInfo title:@(i).description];
        row.value = @(i).description;
        [_form addRow:row];
    }
    [_form removeRowByTag:@(numberOfRows/2)];
    
    NSUInteger indexA = [_section indexOfRow:row];
    NSIndexPath *indexB = [_formDescriptor indexPathForRowDescriptor:row];
    NSIndexPath *indexC = [_form indexPathForRow:row];
    XCTAssertTrue(indexA == numberOfRows-2);
    XCTAssertTrue(indexB.row == numberOfRows-2);
    XCTAssertTrue(indexC.row == numberOfRows-2);
}

#pragma mark - add

- (void)testSectionAddRow
{
    NSUInteger numberOfRows = 100;
    JTRowDescriptor *row;
    for (int i = 0; i < numberOfRows; i++) {
        row = [JTRowDescriptor rowDescriptorWithTag:@(i).description rowType:JTFormRowTypeInfo title:@(i).description];
        row.value = @(i).description;
        [_section addRow:row];
    }
    NSUInteger indexA = [_section indexOfRow:row];
    NSIndexPath *indexB = [_formDescriptor indexPathForRowDescriptor:row];
    NSIndexPath *indexC = [_form indexPathForRow:row];
    XCTAssertTrue(indexA == numberOfRows-1);
    XCTAssertTrue(indexB.row == numberOfRows-1);
    XCTAssertTrue(indexC.row == numberOfRows-1);
}

- (void)testFormAddRow
{
    NSUInteger numberOfRows = 100;
    JTRowDescriptor *row;
    for (int i = 0; i < numberOfRows; i++) {
        row = [JTRowDescriptor rowDescriptorWithTag:@(i).description rowType:JTFormRowTypeInfo title:@(i).description];
        row.value = @(i).description;
        [_form addRow:row];
    }
    NSUInteger indexA = [_section indexOfRow:row];
    NSIndexPath *indexB = [_formDescriptor indexPathForRowDescriptor:row];
    NSIndexPath *indexC = [_form indexPathForRow:row];
    XCTAssertTrue(indexA == numberOfRows-1);
    XCTAssertTrue(indexB.row == numberOfRows-1);
    XCTAssertTrue(indexC.row == numberOfRows-1);
}

- (void)testSectionAddRowWhenOneRowWasHidden
{
    NSUInteger numberOfRows = 100;
    JTRowDescriptor *row;
    for (int i = 0; i < numberOfRows; i++) {
        row = [JTRowDescriptor rowDescriptorWithTag:@(i).description rowType:JTFormRowTypeInfo title:@(i).description];
        row.value = @(i).description;
        if (i == numberOfRows / 2) {
            row.hidden = true;
        }
        [_section addRow:row];
    }
    NSUInteger indexA = [_section indexOfRow:row];
    NSIndexPath *indexB = [_formDescriptor indexPathForRowDescriptor:row];
    NSIndexPath *indexC = [_form indexPathForRow:row];
    XCTAssertTrue(indexA     == numberOfRows-1);
    XCTAssertTrue(indexB.row == numberOfRows-1);
    XCTAssertTrue(indexC.row == numberOfRows-1);
}

- (void)testFormAddRowWhenOneRowWasHidden
{
    NSUInteger numberOfRows = 100;
    JTRowDescriptor *row;
    for (int i = 0; i < numberOfRows; i++) {
        row = [JTRowDescriptor rowDescriptorWithTag:@(i).description rowType:JTFormRowTypeInfo title:@(i).description];
        row.value = @(i).description;
        if (i == numberOfRows / 2) {
            row.hidden = true;
        }
        [_form addRow:row];
    }
    NSUInteger indexA = [_section indexOfRow:row];
    NSIndexPath *indexB = [_formDescriptor indexPathForRowDescriptor:row];
    NSIndexPath *indexC = [_form indexPathForRow:row];
    XCTAssertTrue(indexA     == numberOfRows-1);
    XCTAssertTrue(indexB.row == numberOfRows-1);
    XCTAssertTrue(indexC.row == numberOfRows-1);
}

- (void)testSectionAddRows
{
    NSUInteger numberOfRows = 100;
    NSMutableArray *rows = [NSMutableArray array];
    JTRowDescriptor *row;
    for (int i = 0; i < numberOfRows; i++) {
        row = [JTRowDescriptor rowDescriptorWithTag:@(i).description rowType:JTFormRowTypeInfo title:@(i).description];
        row.value = @(i).description;
        if (i == numberOfRows / 2) {
            row.hidden = true;
        }
        [rows addObject:row];
    }
    [_section addRows:rows];
    
    NSUInteger indexA = [_section indexOfRow:row];
    NSIndexPath *indexB = [_formDescriptor indexPathForRowDescriptor:row];
    NSIndexPath *indexC = [_form indexPathForRow:row];
    XCTAssertTrue(indexA     == numberOfRows-1);
    XCTAssertTrue(indexB.row == numberOfRows-1);
    XCTAssertTrue(indexC.row == numberOfRows-1);
}

- (void)testFormAddRows
{
    NSUInteger numberOfRows = 100;
    NSMutableArray *rows = [NSMutableArray array];
    JTRowDescriptor *row;
    for (int i = 0; i < numberOfRows; i++) {
        row = [JTRowDescriptor rowDescriptorWithTag:@(i).description rowType:JTFormRowTypeInfo title:@(i).description];
        row.value = @(i).description;
        if (i == numberOfRows / 2) {
            row.hidden = true;
        }
        [rows addObject:row];
    }
    [_form addRows:rows];
    
    NSUInteger indexA = [_section indexOfRow:row];
    NSIndexPath *indexB = [_formDescriptor indexPathForRowDescriptor:row];
    NSIndexPath *indexC = [_form indexPathForRow:row];
    XCTAssertTrue(indexA     == numberOfRows-1);
    XCTAssertTrue(indexB.row == numberOfRows-1);
    XCTAssertTrue(indexC.row == numberOfRows-1);
}

- (void)testSectionAddRowAtIndex
{
    NSUInteger numberBeforeAdd = 10;
    JTRowDescriptor *row;
    for (NSInteger i = 0; i < numberBeforeAdd; i++) {
        row = [JTRowDescriptor rowDescriptorWithTag:@(i).description rowType:JTFormRowTypeInfo title:@(i).description];
        row.value = @(i).description;
        [_section addRow:row];
    }
    NSUInteger numberOfRows = 100;
    NSMutableArray *rows = [NSMutableArray array];
    for (int i = 0; i < numberOfRows; i++) {
        NSInteger temp = numberBeforeAdd + i;
        row = [JTRowDescriptor rowDescriptorWithTag:@(temp).description rowType:JTFormRowTypeInfo title:@(temp).description];
        row.value = @(temp).description;
        if (i == numberOfRows / 2) {
            row.hidden = true;
        }
        [rows addObject:row];
    }
    [_section addRows:rows atIndex:numberBeforeAdd/2];
    
    NSUInteger indexA = [_section indexOfRow:row];
    NSIndexPath *indexB = [_formDescriptor indexPathForRowDescriptor:row];
    NSIndexPath *indexC = [_form indexPathForRow:row];
    XCTAssertTrue(indexA     == numberBeforeAdd/2 + numberOfRows-1);
    XCTAssertTrue(indexB.row == numberBeforeAdd/2 + numberOfRows-1);
    XCTAssertTrue(indexC.row == numberBeforeAdd/2 + numberOfRows-1);
}


- (void)testFormAddRowAtIndex
{
    NSUInteger numberBeforeAdd = 10;
    JTRowDescriptor *row;
    for (NSInteger i = 0; i < numberBeforeAdd; i++) {
        row = [JTRowDescriptor rowDescriptorWithTag:@(i).description rowType:JTFormRowTypeInfo title:@(i).description];
        row.value = @(i).description;
        [_form addRow:row];
    }
    NSUInteger numberOfRows = 100;
    NSMutableArray *rows = [NSMutableArray array];
    for (int i = 0; i < numberOfRows; i++) {
        NSInteger temp = numberBeforeAdd + i;
        row = [JTRowDescriptor rowDescriptorWithTag:@(temp).description rowType:JTFormRowTypeInfo title:@(temp).description];
        row.value = @(temp).description;
        if (i == numberOfRows / 2) {
            row.hidden = true;
        }
        [rows addObject:row];
    }
    [_form addRows:rows atIndexPath:[NSIndexPath indexPathForRow:numberBeforeAdd/2 inSection:0]];
    
    NSUInteger indexA = [_section indexOfRow:row];
    NSIndexPath *indexB = [_formDescriptor indexPathForRowDescriptor:row];
    NSIndexPath *indexC = [_form indexPathForRow:row];
    XCTAssertTrue(indexA     == numberBeforeAdd/2 + numberOfRows-1);
    XCTAssertTrue(indexB.row == numberBeforeAdd/2 + numberOfRows-1);
    XCTAssertTrue(indexC.row == numberBeforeAdd/2 + numberOfRows-1);
}

- (void)testSectionAddRowsBeforeRow
{
    NSUInteger numberBeforeAdd = 10;
    JTRowDescriptor *row;
    for (NSInteger i = 0; i < numberBeforeAdd; i++) {
        row = [JTRowDescriptor rowDescriptorWithTag:@(i).description rowType:JTFormRowTypeInfo title:@(i).description];
        row.value = @(i).description;
        [_section addRow:row];
    }
    JTRowDescriptor *middleRow = [_section rowAtIndex:numberBeforeAdd/2 - 1];
    
    NSUInteger numberOfRows = 100;
    NSMutableArray *rows = [NSMutableArray array];
    for (int i = 0; i < numberOfRows; i++) {
        NSInteger temp = numberBeforeAdd + i;
        row = [JTRowDescriptor rowDescriptorWithTag:@(temp).description rowType:JTFormRowTypeInfo title:@(temp).description];
        row.value = @(temp).description;
        if (i == numberOfRows / 2) {
            row.hidden = true;
        }
        [rows addObject:row];
    }
    [_section addRows:rows beforeRow:middleRow];
    
    NSUInteger indexA = [_section indexOfRow:middleRow];
    NSIndexPath *indexB = [_formDescriptor indexPathForRowDescriptor:middleRow];
    NSIndexPath *indexC = [_form indexPathForRow:middleRow];
    XCTAssertTrue(indexA     == numberBeforeAdd/2 + numberOfRows-1);
    XCTAssertTrue(indexB.row == numberBeforeAdd/2 + numberOfRows-1);
    XCTAssertTrue(indexC.row == numberBeforeAdd/2 + numberOfRows-1);
}

- (void)testSectionAddRowsAfterRow
{
    NSUInteger numberBeforeAdd = 10;
    JTRowDescriptor *row;
    for (NSInteger i = 0; i < numberBeforeAdd; i++) {
        row = [JTRowDescriptor rowDescriptorWithTag:@(i).description rowType:JTFormRowTypeInfo title:@(i).description];
        row.value = @(i).description;
        [_section addRow:row];
    }
    JTRowDescriptor *middleRow = [_section rowAtIndex:numberBeforeAdd/2 - 1];
    
    NSUInteger numberOfRows = 100;
    NSMutableArray *rows = [NSMutableArray array];
    for (int i = 0; i < numberOfRows; i++) {
        NSInteger temp = numberBeforeAdd + i;
        row = [JTRowDescriptor rowDescriptorWithTag:@(temp).description rowType:JTFormRowTypeInfo title:@(temp).description];
        row.value = @(temp).description;
        if (i == numberOfRows / 2) {
            row.hidden = true;
        }
        [rows addObject:row];
    }
    [_section addRows:rows afterRow:middleRow];
    
    NSUInteger indexA = [_section indexOfRow:row];
    NSIndexPath *indexB = [_formDescriptor indexPathForRowDescriptor:row];
    NSIndexPath *indexC = [_form indexPathForRow:row];
    XCTAssertTrue(indexA     == numberBeforeAdd/2 + numberOfRows-1);
    XCTAssertTrue(indexB.row == numberBeforeAdd/2 + numberOfRows-1);
    XCTAssertTrue(indexC.row == numberBeforeAdd/2 + numberOfRows-1);
}

- (void)testFormAddRowsBeforeRow
{
    NSUInteger numberBeforeAdd = 10;
    JTRowDescriptor *row;
    for (NSInteger i = 0; i < numberBeforeAdd; i++) {
        row = [JTRowDescriptor rowDescriptorWithTag:@(i).description rowType:JTFormRowTypeInfo title:@(i).description];
        row.value = @(i).description;
        [_form addRow:row];
    }
    JTRowDescriptor *middleRow = [_section rowAtIndex:numberBeforeAdd/2 - 1];
    
    NSUInteger numberOfRows = 100;
    NSMutableArray *rows = [NSMutableArray array];
    for (int i = 0; i < numberOfRows; i++) {
        NSInteger temp = numberBeforeAdd + i;
        row = [JTRowDescriptor rowDescriptorWithTag:@(temp).description rowType:JTFormRowTypeInfo title:@(temp).description];
        row.value = @(temp).description;
        if (i == numberOfRows / 2) {
            row.hidden = true;
        }
        [rows addObject:row];
    }
    [_form addRows:rows beforeRow:middleRow];
    
    NSUInteger indexA = [_section indexOfRow:middleRow];
    NSIndexPath *indexB = [_formDescriptor indexPathForRowDescriptor:middleRow];
    NSIndexPath *indexC = [_form indexPathForRow:middleRow];
    XCTAssertTrue(indexA     == numberBeforeAdd/2 + numberOfRows-1);
    XCTAssertTrue(indexB.row == numberBeforeAdd/2 + numberOfRows-1);
    XCTAssertTrue(indexC.row == numberBeforeAdd/2 + numberOfRows-1);
}

- (void)testFormAddRowsAfterRow
{
    NSUInteger numberBeforeAdd = 10;
    JTRowDescriptor *row;
    for (NSInteger i = 0; i < numberBeforeAdd; i++) {
        row = [JTRowDescriptor rowDescriptorWithTag:@(i).description rowType:JTFormRowTypeInfo title:@(i).description];
        row.value = @(i).description;
        [_form addRow:row];
    }
    JTRowDescriptor *middleRow = [_section rowAtIndex:numberBeforeAdd/2 - 1];
    
    NSUInteger numberOfRows = 100;
    NSMutableArray *rows = [NSMutableArray array];
    for (int i = 0; i < numberOfRows; i++) {
        NSInteger temp = numberBeforeAdd + i;
        row = [JTRowDescriptor rowDescriptorWithTag:@(temp).description rowType:JTFormRowTypeInfo title:@(temp).description];
        row.value = @(temp).description;
        if (i == numberOfRows / 2) {
            row.hidden = true;
        }
        [rows addObject:row];
    }
    [_form addRows:rows afterRow:middleRow];
    
    NSUInteger indexA = [_section indexOfRow:row];
    NSIndexPath *indexB = [_formDescriptor indexPathForRowDescriptor:row];
    NSIndexPath *indexC = [_form indexPathForRow:row];
    XCTAssertTrue(indexA     == numberBeforeAdd/2 + numberOfRows-1);
    XCTAssertTrue(indexB.row == numberBeforeAdd/2 + numberOfRows-1);
    XCTAssertTrue(indexC.row == numberBeforeAdd/2 + numberOfRows-1);
}

#pragma mark - other

- (void)testAddRowBeforeFormWasCreated
{
    __block JTRowDescriptor *row;
    // 行数过多时，添加时速度会变慢，但因为一般表单不会显示这么多行，所以先不处理
    NSInteger numberOfRows = 1000;
    
    // with lock:0.385，0.394，0.322，0.413，0.377，0.434，0.404，0.39 ，0.43 ，0.403   average:0.3952
    //   no lock:0.365，0.447，0.443，0.397，0.43 ，0.458，0.385，0.366，0.429，0.372   average:0.4092
    [self measureBlock:^{
        for (NSInteger i = 0; i < numberOfRows; i++) {
            row = [JTRowDescriptor rowDescriptorWithTag:@(i).description rowType:JTFormRowTypeInfo title:@(i).description];
            row.value = @(i).description;
            [_section addRow:row];
        }
    }];
}

- (void)testAddRowAfterFormWasCreated
{
    XCTestExpectation *e1 = [self expectationWithDescription:@"my async test 01"];
    
    __block JTRowDescriptor *row;
    // 行数过多时，添加时速度会变慢，但因为一般表单不会显示这么多行，所以先不处理
    NSInteger numberOfRows = 1000;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kJTScreenWidth, kJTScreenHeight)];
    JTForm *form = [JTForm formWithDescriptor:_formDescriptor];
    [view addSubview:form];
    
    // with lock:0.369，0.385，0.322，0.372，0.41 ，0.387，0.408，0.39 ，0.391，0.433   average:0.3867
    //   no lock:0.379，0.38 ，0.367，0.396，0.374，0.39 ，0.409，0.403，0.384，0.429   average:0.3911
    [self measureBlock:^{
        for (NSInteger i = 0; i < numberOfRows; i++) {
            row = [JTRowDescriptor rowDescriptorWithTag:@(i).description rowType:JTFormRowTypeInfo title:@(i).description];
            row.value = @(i).description;
            [_section addRow:row];
        }
    }];
    [form.tableNode waitUntilAllUpdatesAreProcessed];
    [form.tableNode onDidFinishProcessingUpdates:^{
        [e1 fulfill];
    }];
//    [_section.formRows removeAllObjects];
    [self waitForExpectationsWithTimeout:10. handler:nil];
}

#pragma mark - helper

- (void)triggerFirstLayoutMeasurementForTableNode:(ASTableNode *)tableNode
{
    [tableNode reloadData];
    [tableNode.view setNeedsLayout];
    [tableNode.view layoutIfNeeded];
    [tableNode waitUntilAllUpdatesAreProcessed];
}

@end
