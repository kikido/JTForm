//
//  JTFormUITest.m
//  JTFormTests
//
//  Created by dqh on 2020/11/3.
//  Copyright © 2020 dqh. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JTHelper.h"
#import "JTForm.h"
#import "JTBaseCell.h"
#import "NSObject+JTAdd.h"
#import "JTFormRegexValidator.h"

#import <KIF.h>
#import <UIApplication-KIFAdditions.h>
#import <KIFUITestActor_Private.h>

#define NumberOfSections 2
#define NumberOfRows 10
#define kWaitTimeInterval 3.
#define kArrayOfTypes (@[@"JTFormRowTypeFloatText", @"JTFormRowTypeText", @"JTFormRowTypeName", @"JTFormRowTypeEmail", @"JTFormRowTypeNumber", @"JTFormRowTypeInteger", @"JTFormRowTypeDecimal", @"JTFormRowTypePassword", @"JTFormRowTypePhone", @"JTFormRowTypeURL", @"JTFormRowTypeTextView", \
@"JTFormRowTypeLongInfo", @"JTFormRowTypeInfo", \
@"JTFormRowTypePushSelect", @"JTFormRowTypeMultipleSelect", @"JTFormRowTypePushButton", \
@"JTFormRowTypeSheetSelect", @"JTFormRowTypeAlertSelect", @"JTFormRowTypePickerSelect", \
@"JTFormRowTypeDate", @"JTFormRowTypeTime", @"JTFormRowTypeDateTime", @"JTFormRowTypeCountDownTimer", \
@"JTFormRowTypeDateInline", @"JTFormRowTypeTimeInline", @"JTFormRowTypeDateTimeInline", @"JTFormRowTypeCountDownTimerInline", \
@"JTFormRowTypeSwitch", @"JTFormRowTypeCheck", @"JTFormRowTypeStepCounter", @"JTFormRowTypeSegmentedControl", @"JTFormRowTypeSlider"])

@interface JTFormUITest : KIFTestCase

@end

@implementation JTFormUITest {
    JTForm *_form;
    JTFormDescriptor *_formDescriptor;
    JTSectionDescriptor *_section;
    JTRowDescriptor *_row;
}

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    
    [tester waitForViewWithAccessibilityLabel:@"form one"];
    [tester tapViewWithAccessibilityLabel:@"form one"];
    _form = (JTForm *)[tester waitForViewWithAccessibilityLabel:@"form"];
    _formDescriptor = _form.formDescriptor;
}

- (void)tearDown {
    [_form removeFromSuperview];
    _form = nil;
    _formDescriptor = nil;
    _section = nil;
    _row = nil;

    [tester tapViewWithAccessibilityLabel:NSLocalizedString(@"Back", nil) traits:UIAccessibilityTraitButton];
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)beforeEach
{
    [tester waitForViewWithAccessibilityLabel:@"form one"];
    [tester tapViewWithAccessibilityLabel:@"form one"];
    
    _form = (JTForm *)[tester waitForViewWithAccessibilityLabel:@"form"];
}

- (void)afterEach
{
//    [tester tapViewWithAccessibilityLabel:NSLocalizedString(@"Back", nil) traits:UIAccessibilityTraitButton];
//    _form = nil;
//    _formDescriptor = nil;
//    _section = nil;
//    _row = nil;
}

- (void)beforeAll
{
//    [tester waitForViewWithAccessibilityLabel:@"form one"];
//    [tester tapViewWithAccessibilityLabel:@"form one"];
//
//    _form = (JTForm *)[tester waitForViewWithAccessibilityLabel:@"form"];
}

- (void)afterAll
{
//    [tester tapViewWithAccessibilityLabel:NSLocalizedString(@"Back", nil) traits:UIAccessibilityTraitButton];
//    _form = nil;
//    _formDescriptor = nil;
//    _section = nil;
//    _row = nil;
}

//@"JTFormRowTypeFloatText", @"JTFormRowTypeText", @"JTFormRowTypeName", @"JTFormRowTypeEmail", @"JTFormRowTypeNumber", @"JTFormRowTypeInteger", @"JTFormRowTypeDecimal", @"JTFormRowTypePassword", @"JTFormRowTypePhone", @"JTFormRowTypeURL", @"JTFormRowTypeTextView",
//@"JTFormRowTypeLongInfo", @"JTFormRowTypeInfo",
//@"JTFormRowTypePushSelect", @"JTFormRowTypeMultipleSelect", @"JTFormRowTypePushButton",
//@"JTFormRowTypeSheetSelect", @"JTFormRowTypeAlertSelect", @"JTFormRowTypePickerSelect",
//@"JTFormRowTypeDate", @"JTFormRowTypeTime", @"JTFormRowTypeDateTime", @"JTFormRowTypeCountDownTimer",
//@"JTFormRowTypeDateInline", @"JTFormRowTypeTimeInline", @"JTFormRowTypeDateTimeInline", @"JTFormRowTypeCountDownTimerInline",
//@"JTFormRowTypeSwitch", @"JTFormRowTypeCheck", @"JTFormRowTypeStepCounter", @"JTFormRowTypeSegmentedControl", @"JTFormRowTypeSlider"

#pragma mark - cell

- (void)setValue:(id)value forRowDescriptor:(JTRowDescriptor *)rowDescriptor
{
    XCTAssertNotNil(rowDescriptor);
    NSString *tag = rowDescriptor.tag;
    
}

- (void)tapRowDescriptor:(JTRowDescriptor *)rowDescriptor
{
    
}




- (void)testCellBeFirstResponder
{
    // this can be first responder
    NSArray *tags = @[@"JTFormRowTypeFloatText", @"JTFormRowTypeText", @"JTFormRowTypeName", @"JTFormRowTypeEmail", @"JTFormRowTypeNumber", @"JTFormRowTypeInteger", @"JTFormRowTypeDecimal", @"JTFormRowTypePassword", @"JTFormRowTypePhone", @"JTFormRowTypeURL", @"JTFormRowTypeTextView", @"JTFormRowTypeDate", @"JTFormRowTypeTime", @"JTFormRowTypeDateTime", @"JTFormRowTypeCountDownTimer", @"JTFormRowTypeDateInline", @"JTFormRowTypeTimeInline", @"JTFormRowTypeDateTimeInline", @"JTFormRowTypeCountDownTimerInline"];
    for (NSString *tag in tags) {
        _row = [_form findRowByTag:tag];
        [self makeRowDescriptorBecomeFirstResponder:_row];
        XCTAssertTrue([_row.cellForDescriptor jt_isFirstResponder]);
        
        [_row.cellForDescriptor resignFirstResponder];
        XCTAssertFalse([_row.cellForDescriptor jt_isFirstResponder]);
    }
}

- (void)testCellAllStatusColorAndFont
{
    // title: common disabled high_light
    // content: common disabled
    UIColor *titleCommonColor = UIColorHex(f8e64e);
    UIColor *titleDisabledColor = UIColorHex(e6a441);
    UIColor *contentCommonColor = UIColorHex(3e332a);
    UIColor *contentDisabledColor = UIColorHex(8d553b);
    UIColor *titleHighColor = UIColorHex(33e33e);

    UIFont *titleCommonFont = [UIFont systemFontOfSize:15.];
    UIFont *titleDisabledFont = [UIFont systemFontOfSize:16.];
    UIFont *contentCommonFont = [UIFont systemFontOfSize:17.];
    UIFont *contentDisabledFont = [UIFont systemFontOfSize:13.];
    UIFont *titleHighFont = [UIFont systemFontOfSize:12.];
    
    NSArray *tags = kArrayOfTypes;
    for (NSString *tag in tags) {
        _row = [_form findRowByTag:tag];
        _row.configModel.titleColor = titleCommonColor;
        _row.configModel.disabledTitleColor = titleDisabledColor;
        _row.configModel.contentColor = contentCommonColor;
        _row.configModel.disabledContentColor = contentDisabledColor;
        _row.configModel.highLightTitleColor = titleHighColor;
        
        _row.configModel.titleFont = titleCommonFont;
        _row.configModel.disabledTitleFont = titleDisabledFont;
        _row.configModel.contentFont = contentCommonFont;
        _row.configModel.disabledContentFont = contentDisabledFont;
        _row.configModel.highLightTitleFont = titleHighFont;
    }
    [_form updateAllRows];
    
    // all types: common title
    for (NSString *tag in tags) {
        _row = [_form findRowByTag:tag];
        NSIndexPath *indexpath = [_form indexPathForRow:_row];
        [tester waitForCellAtIndexPath:indexpath inTableView:_form.tableView];
        if (![tag isEqualToString:JTFormRowTypeFloatText]) {
            UIColor *color1 = [_row.cellForDescriptor.titleNode.attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
            UIFont *fontT = [_row.cellForDescriptor.titleNode.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];

            XCTAssertTrue([self compareColor:color1 toColor:titleCommonColor]);
            XCTAssertTrue([fontT isEqual:titleCommonFont]);
        }
    }

    // textfield input types:
    tags = @[@"JTFormRowTypeText", @"JTFormRowTypeName", @"JTFormRowTypeEmail", @"JTFormRowTypeNumber", @"JTFormRowTypeInteger", @"JTFormRowTypeDecimal", @"JTFormRowTypePassword", @"JTFormRowTypePhone", @"JTFormRowTypeURL"];
    for (NSString *tag in tags) {
        _row = [_form findRowByTag:tag];
        UIView *cell = [tester waitForViewWithAccessibilityLabel:tag];
        [tester enterText:@"1" intoElement:nil inView:cell expectedResult:nil];
        UIColor *colorT = [_row.cellForDescriptor.titleNode.attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
        UIFont *fontTH = [_row.cellForDescriptor.titleNode.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
        XCTAssertTrue([self compareColor:colorT toColor:titleHighColor]);
        XCTAssertTrue([fontTH isEqual:titleHighFont]);

        ASDisplayNode *node = [_row.cellForDescriptor valueForKey:@"textFieldNode"];
        UITextField *tf = (UITextField *)node.view;
        UIColor *colorC = tf.textColor;
        UIFont *fontC = tf.font;
        XCTAssertTrue([self compareColor:colorC toColor:contentCommonColor]);
        XCTAssertTrue([fontC isEqual:contentCommonFont]);

        _row.disabled = YES;
        UIColor *colorCD = tf.textColor;
        UIFont *fontCD = tf.font;
        XCTAssertTrue([self compareColor:colorCD toColor:contentDisabledColor]);
        XCTAssertTrue([fontCD isEqual:contentDisabledFont]);
    }
    
//     textview input types:
    tags = @[@"JTFormRowTypeTextView"];
    for (NSString *tag in tags) {
        _row = [_form findRowByTag:tag];
        UIView *cell = [tester waitForViewWithAccessibilityLabel:tag];
        [tester enterText:@"zzzz" intoElement:nil inView:cell expectedResult:nil];
        UIColor *colorT = [_row.cellForDescriptor.titleNode.attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
        UIFont *fontTH = [_row.cellForDescriptor.titleNode.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
        XCTAssertTrue([self compareColor:colorT toColor:titleHighColor]);
        XCTAssertTrue([fontTH isEqual:titleHighFont]);

        ASEditableTextNode *node = [_row.cellForDescriptor valueForKey:@"textViewNode"];
        UIColor *colorC = [node.attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
        UIFont *fontC = [node.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
        XCTAssertTrue([self compareColor:colorC toColor:contentCommonColor]);
        XCTAssertTrue([fontC isEqual:contentCommonFont]);

        _row.disabled = YES;
        UIColor *colorCD = [node.attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
        UIFont *fontCD = [node.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
        XCTAssertTrue([self compareColor:colorCD toColor:contentDisabledColor]);
        XCTAssertTrue([fontCD isEqual:contentDisabledFont]);
    }

    // date types: high light title color
    tags = @[@"JTFormRowTypeDate", @"JTFormRowTypeTime", @"JTFormRowTypeDateTime", @"JTFormRowTypeCountDownTimer", @"JTFormRowTypeDateInline", @"JTFormRowTypeTimeInline", @"JTFormRowTypeDateTimeInline", @"JTFormRowTypeCountDownTimerInline"];
    if (@available(iOS 14.0, *)) {
    } else {
        for (NSString *tag in tags) {
            _row = [_form findRowByTag:tag];
            NSIndexPath *indexpath = [_form indexPathForRow:_row];
            [tester tapRowAtIndexPath:indexpath inTableView:_form.tableView];
            UIColor *color = [_row.cellForDescriptor.titleNode.attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
            UIFont *font = [_row.cellForDescriptor.titleNode.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
            XCTAssertTrue([self compareColor:color toColor:titleHighColor]);
            XCTAssertTrue([font isEqual:titleHighFont]);
            [_row.cellForDescriptor resignFirstResponder];
            
            UIColor *colorC = [_row.cellForDescriptor.contentNode.attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
            UIFont *fontC = [_row.cellForDescriptor.contentNode.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
            XCTAssertTrue([self compareColor:colorC toColor:contentCommonColor]);
            XCTAssertTrue([fontC isEqual:contentCommonFont]);

            _row.disabled = YES;
            UIColor *colorCD = [_row.cellForDescriptor.contentNode.attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
            UIFont *fontCD = [_row.cellForDescriptor.contentNode.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
            XCTAssertTrue([self compareColor:colorCD toColor:contentDisabledColor]);
            XCTAssertTrue([fontCD isEqual:contentDisabledFont]);
        }
    }

    // select types
    tags = @[@"JTFormRowTypePushSelect", @"JTFormRowTypeMultipleSelect", @"JTFormRowTypeSheetSelect", @"JTFormRowTypeAlertSelect", @"JTFormRowTypePickerSelect"];
    for (int i = 0; i < tags.count; i++) {
        NSString *tag = tags[i];
        _row = [_form findRowByTag:tag];
        [tester tapViewWithAccessibilityLabel:tag];

        if ([tag isEqualToString:JTFormRowTypePushSelect] || [tag isEqualToString:JTFormRowTypeMultipleSelect]) {
            // push select
            [tester waitForViewWithAccessibilityLabel:@"tableview"];
            [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"tableview"];
            if ([tag isEqualToString:JTFormRowTypeMultipleSelect]) {
                // 返回前一页
                [tester tapViewWithAccessibilityLabel:NSLocalizedString(@"Back", nil) traits:UIAccessibilityTraitButton];
            }
        } else {
            [tester waitForViewWithAccessibilityLabel:@"西瓜"];
            [tester tapViewWithAccessibilityLabel:@"西瓜"];
            if ([tag isEqualToString:JTFormRowTypePickerSelect]) {
                [_row.cellForDescriptor resignFirstResponder];
            }
        }
        UIColor *colorC = [_row.cellForDescriptor.contentNode.attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
        UIFont *fontC = [_row.cellForDescriptor.contentNode.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
        XCTAssertTrue([self compareColor:colorC toColor:contentCommonColor]);
        XCTAssertTrue([fontC isEqual:contentCommonFont]);

        _row.disabled = YES;
        UIColor *colorCD = [_row.cellForDescriptor.contentNode.attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
        UIFont *fontCD = [_row.cellForDescriptor.contentNode.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
        XCTAssertTrue([self compareColor:colorCD toColor:contentDisabledColor]);
        XCTAssertTrue([fontCD isEqual:contentDisabledFont]);
    }
    
    // other
    // //@"JTFormRowTypeSwitch", @"JTFormRowTypeCheck", @"JTFormRowTypeStepCounter", @"JTFormRowTypeSegmentedControl", @"JTFormRowTypeSlider"
    // JTFormRowTypeInfo
    _row = [_form findRowByTag:@"JTFormRowTypeInfo"];
    _row.value = @"info";
    [_row updateCell];
    ASDisplayNode *node = [_row.cellForDescriptor valueForKey:@"textFieldNode"];
    UITextField *tf = (UITextField *)node.view;
    XCTAssertTrue([self compareColor:tf.textColor toColor:contentDisabledColor]);
    _row.disabled = true;

    // JTFormRowTypeLongInfo
    _row = [_form findRowByTag:@"JTFormRowTypeLongInfo"];
    _row.value = @"long info";
    _row.disabled = true;

    // JTFormRowTypeStepCounter
    UIColor *colorC;
    _row = [_form findRowByTag:@"JTFormRowTypeStepCounter"];
    _row.value = @(4);
    [_row updateCell];
    colorC = [_row.cellForDescriptor.contentNode.attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
    XCTAssertTrue([self compareColor:colorC toColor:contentCommonColor]);

    _row.disabled = YES;
    UIColor *colorCD = [_row.cellForDescriptor.contentNode.attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
    XCTAssertTrue([self compareColor:colorCD toColor:contentDisabledColor]);
    
    // JTFormRowTypeSlider
    _row = [_form findRowByTag:@"JTFormRowTypeSlider"];
    _row.value = @(0.4);
    [_row updateCell];
    colorC = [_row.cellForDescriptor.contentNode.attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
    XCTAssertTrue([self compareColor:colorC toColor:contentCommonColor]);

    _row.disabled = YES;
    colorCD = [_row.cellForDescriptor.contentNode.attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
    XCTAssertTrue([self compareColor:colorCD toColor:contentDisabledColor]);
    
    tags = kArrayOfTypes;
    for (NSString *tag in tags) {
        if ([tag isEqualToString:JTFormRowTypeFloatText]) {
            continue;
        }
        _row = [_form findRowByTag:tag];
        _row.disabled = true;
        NSIndexPath *indexpath = [_form indexPathForRow:_row];
        [tester waitForCellAtIndexPath:indexpath inTableView:_form.tableView];
        UIColor *colorTD = [_row.cellForDescriptor.titleNode.attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
        UIFont *fontTD = [_row.cellForDescriptor.titleNode.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
        XCTAssertTrue([self compareColor:colorTD toColor:titleDisabledColor]);
        XCTAssertTrue([fontTD isEqual:titleDisabledFont]);
    }
}

// cell title high light color for some type
- (void)testCellHighLight
{
    NSArray *tags = @[@"JTFormRowTypeFloatText", @"JTFormRowTypeText", @"JTFormRowTypeName", @"JTFormRowTypeEmail", @"JTFormRowTypeNumber", @"JTFormRowTypeInteger", @"JTFormRowTypeDecimal", @"JTFormRowTypePassword", @"JTFormRowTypePhone", @"JTFormRowTypeURL", @"JTFormRowTypeTextView"];
    UIColor *targetColor = UIColorHex(f8e64e);
    
    for (NSString *tag in tags) {
        _row = [_form findRowByTag:tag];
        UIView *cell = [tester waitForViewWithAccessibilityLabel:tag];
        [tester enterText:@"1" intoElement:nil inView:cell expectedResult:nil];
        UIColor *color = [_row.cellForDescriptor.titleNode.attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
        XCTAssertTrue([self compareColor:color toColor:kJTFormCellHighLightColor]);
        [cell resignFirstResponder];
    }
    for (NSString *tag in tags) {
        _row = [_form findRowByTag:tag];
        _row.required = true;
        _row.configModel.highLightTitleColor = targetColor;
    }
    for (NSString *tag in tags) {
        _row = [_form findRowByTag:tag];
        UIView *cell = [tester waitForViewWithAccessibilityLabel:tag];
        [tester enterText:@"1" intoElement:nil inView:cell expectedResult:nil];
        UIColor *color = [_row.cellForDescriptor.titleNode.attributedText attribute:NSForegroundColorAttributeName atIndex:1 effectiveRange:nil];
        XCTAssertTrue([self compareColor:color toColor:targetColor]);
        [cell resignFirstResponder];
    }
    
    
    tags = @[@"JTFormRowTypeDate", @"JTFormRowTypeTime", @"JTFormRowTypeDateTime", @"JTFormRowTypeCountDownTimer", @"JTFormRowTypeDateInline", @"JTFormRowTypeTimeInline", @"JTFormRowTypeDateTimeInline", @"JTFormRowTypeCountDownTimerInline"];
    if (@available(iOS 14.0, *)) {
    } else {
        for (NSString *tag in tags) {
            _row = [_form findRowByTag:tag];
            NSIndexPath *indexpath = [_form indexPathForRow:_row];
            [tester tapRowAtIndexPath:indexpath inTableView:_form.tableView];
            UIColor *color = [_row.cellForDescriptor.titleNode.attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
            XCTAssertTrue([self compareColor:color toColor:kJTFormCellHighLightColor]);
            [_row.cellForDescriptor resignFirstResponder];
        }
    }
    for (NSString *tag in tags) {
        _row = [_form findRowByTag:tag];
        _row.configModel.highLightTitleColor = targetColor;
    }
    if (@available(iOS 14.0, *)) {
    } else {
        for (NSString *tag in tags) {
            _row = [_form findRowByTag:tag];
            NSIndexPath *indexpath = [_form indexPathForRow:_row];
            [tester tapRowAtIndexPath:indexpath inTableView:_form.tableView];
            UIColor *color = [_row.cellForDescriptor.titleNode.attributedText attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
            XCTAssertTrue([self compareColor:color toColor:targetColor]);
            [_row.cellForDescriptor resignFirstResponder];
        }
    }
}

- (void)testCellTitleNodeArrtibuteString
{
    _form.formDescriptor.addAsteriskToRequiredRowsTitle = true;
    _row = [_form findRowByTag:@"JTFormRowTypeText"];
    _row.required = true;
    XCTAssertTrue([[_row.cellForDescriptor titleDisplayAttributeString].string containsString:@"*"]);
    
    _row.required = false;
    XCTAssertFalse([[_row.cellForDescriptor titleDisplayAttributeString].string containsString:@"*"]);
}

- (void)testFindForm
{
    _row = [_form findRowByTag:@"JTFormRowTypeText"];
    JTForm *form = [_row.cellForDescriptor findForm];
    XCTAssertEqual(_form, form);
    
    [_form removeRow:_row];
    form = [_row.cellForDescriptor findForm];
    XCTAssertNil(form);
}

#pragma mark - form

- (void)testRowAndSectionAreRemoved
{
    JTSectionDescriptor *section = [JTSectionDescriptor formSection];
    [_form addSection:section];
    
    JTRowDescriptor *row = [JTRowDescriptor rowDescriptorWithTag:nil rowType:JTFormRowTypeInfo title:nil];
    [section addRow:row];
    
    XCTAssertNotNil(row.sectionDescriptor);
    XCTAssertNotNil(section.formDescriptor);

    [section removeRow:row];
    [_form removeSection:section];

    XCTAssertNil(row.sectionDescriptor);
    XCTAssertNil(section.formDescriptor);
}

- (void)testRowsRequired
{
    _form.formDescriptor.addAsteriskToRequiredRowsTitle = true;
    
    NSArray *tags = @[@"JTFormRowTypeText", @"JTFormRowTypeName", @"JTFormRowTypeEmail", @"JTFormRowTypeNumber"];
    [_form setRowsRequired:true byTags:tags];
    NSArray *errors = [_form formValidationErrors];
    for (NSError *error in errors) {
        _row = error.userInfo[JTRowDescriptorErrorKey];
        bool existed = false;
        for (NSString *tag in tags) {
            if ([tag isEqualToString:_row.tag]) {
                existed = true;
                break;;
            }
        }
        XCTAssertTrue(existed);
    }
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeInterval]];
}

- (void)testRowsDisabled
{
    NSArray *tags = @[@"JTFormRowTypeText", @"JTFormRowTypeName", @"JTFormRowTypeEmail", @"JTFormRowTypeNumber"];
    [_form setRowsDisabled:true byTags:tags];
    for (NSString *tag in tags) {
        _row = [_form findRowByTag:tag];
        XCTAssertFalse([_row.cellForDescriptor canBecomeFirstResponder]);
    }
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeInterval]];
}

- (void)testSetRowsHidden
{
    NSUInteger fromCount = [_form.formDescriptor.formSections.firstObject.formRows count];
    NSArray *tags = @[@"JTFormRowTypeText", @"JTFormRowTypeName", @"JTFormRowTypeEmail", @"JTFormRowTypeNumber"];
    [_form setRowsHidden:true byTags:tags];
    XCTAssertEqual(fromCount-4, [_form.formDescriptor.formSections.firstObject.formRows count]);
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeInterval]];
}

- (void)testFormHttpValues
{
    _row = [_form findRowByTag:@"JTFormRowTypeText"];
    _row.value = @"";
    
    _row = [_form findRowByTag:@"JTFormRowTypeMultipleSelect"];
    _row.value = [JTOptionObject optionObjectsWithOptionValues:@[@"1", @"2"] optionTexts:@[@"t1", @"y2"]];
    
    _row = [_form findRowByTag:@"JTFormRowTypeText"];
    _row.hidden = true;
    
    NSArray *tags = kArrayOfTypes;
    NSDictionary *values = [_form formHttpValues];
    for (NSString *tag in tags) {
        id value = values[tag];
        XCTAssertNotNil(value);
        
        if ([tag isEqualToString:@"JTFormRowTypeMultipleSelect"]) {
            XCTAssertTrue([value isKindOfClass:[NSArray class]]);
            NSString *valueString = [(NSArray *)value componentsJoinedByString:@","];
            XCTAssertTrue([valueString isEqualToString:@"1,2"]);
        } else {
            XCTAssertTrue([value isKindOfClass:[NSNull class]]);
        }
    }
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeInterval]];
}

- (void)testFormValues
{
    _row = [_form findRowByTag:@"JTFormRowTypeText"];
    _row.value = @"";
    
    _row = [_form findRowByTag:@"JTFormRowTypeMultipleSelect"];
    _row.value = [JTOptionObject optionObjectsWithOptionValues:@[@"1", @"2"] optionTexts:@[@"t1", @"y2"]];
    
    _row = [_form findRowByTag:@"JTFormRowTypeText"];
    _row.hidden = true;
    
    NSArray *tags = kArrayOfTypes;
    NSDictionary *values = [_form formValues];
    for (NSString *tag in tags) {
        id value = values[tag];
        XCTAssertNotNil(value);
        
        if ([tag isEqualToString:@"JTFormRowTypeMultipleSelect"]) {
            XCTAssertTrue([value isKindOfClass:[NSArray class]]);
            XCTAssertTrue([(NSArray *)value count] == 2);
        } else {
            XCTAssertTrue([value isKindOfClass:[NSNull class]]);
        }
    }
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeInterval]];
}

#pragma mark - section

- (void)testFormNoValueShowText
{
    //     NSArray *selectTags = @[@"JTFormRowTypePushSelect", @"JTFormRowTypeMultipleSelect", @"JTFormRowTypeSheetSelect", @"JTFormRowTypeAlertSelect", @"JTFormRowTypePickerSelect"];
    _formDescriptor.noValueShowText = true;
    _row = [_form findRowByTag:@"JTFormRowTypePushSelect"];
    [_form ensureRowIsVisible:_row];
    
    _row.value = [JTOptionObject optionsObjectWithOptionValue:[NSNull null] optionText:@"没有值但可以显示我"];
    [_row updateCell];
    XCTAssertTrue([_row.cellForDescriptor.contentNode.attributedText.string isEqualToString:@"没有值但可以显示我"]);

    _formDescriptor.noValueShowText = false;
    [_row updateCell];
    XCTAssertTrue(_row.cellForDescriptor.contentNode.attributedText.string.length == 0);
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeInterval]];
}

- (void)testSectionHeaderView
{
    CGRect headerRect = [_form.tableView rectForHeaderInSection:0];
    CGRect footerRect = [_form.tableView rectForFooterInSection:0];
    JTSectionDescriptor *section = [_form.formDescriptor sectionAtIndex:0];
    XCTAssertTrue(headerRect.size.height == section.headerHeight);
    XCTAssertTrue(footerRect.size.height == section.footerHeight);
}

- (void)testSectionOptions
{
    _section = [JTSectionDescriptor formSection];
    _section.sectionOptions = JTSectionOptionCanDelete;
    
    for (int i = 0; i < 10; i++) {
        NSString *tag = [NSString stringWithFormat:@"%@-%d", NSStringFromSelector(_cmd), i];
        _row = [JTRowDescriptor rowDescriptorWithTag:tag rowType:JTFormRowTypeInfo title:tag];
        _row.cellForDescriptor.accessibilityLabel = tag;
        [_section addRow:_row];
    }
    [_form.formDescriptor addSections:@[_section] atIndex:0];
    
    [tester swipeViewWithAccessibilityLabel:[NSString stringWithFormat:@"%@-0", NSStringFromSelector(_cmd)] inDirection:KIFSwipeDirectionLeft];
    UITableViewCell *cell = [_form.tableNode cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [tester waitForDeleteStateForCell:(UITableViewCell *)cell];
    [tester tapViewWithAccessibilityLabel:@"Delete"];
    
    JTSectionDescriptor *section = [_form.formDescriptor sectionAtIndex:0];
    XCTAssertTrue(section.formRows.count == 9);
}

#pragma mark - row

- (void)testCellForRowIsExist
{
    JTRowDescriptor *row = [JTRowDescriptor rowDescriptorWithTag:@"node" rowType:JTFormRowTypeInfo title:nil];
    XCTAssertFalse(row.isCellExist);
    
    [_form addRow:row];
    XCTAssertTrue(row.isCellExist);
}

- (void)testRowTag
{
    NSString *tag = NSStringFromSelector(_cmd);
    _row = [JTRowDescriptor rowDescriptorWithTag:tag rowType:JTFormRowTypeInfo title:tag];
    [_form addRow:_row];
    JTRowDescriptor *row = [_form findRowByTag:tag];
    XCTAssertEqual(_row, row);
    [_form removeRow:row];
    row = [_form findRowByTag:tag];
    XCTAssertNil(row);
}

- (void)testRowManualSetValue
{
    NSString *newValue = NSStringFromSelector(_cmd);
    _row = [JTRowDescriptor rowDescriptorWithTag:NSStringFromSelector(_cmd) rowType:JTFormRowTypeText title:NSStringFromSelector(_cmd)];
    _row.valueChangeBlock = ^(id  _Nullable oldValue, id  _Nonnull newValue, JTRowDescriptor * _Nonnull sender) {
        XCTAssertTrue([newValue isEqualToString:newValue]);
    };
    [_section addRow:_row];
    
    [_row manualSetValue:newValue];
}

- (void)testRowRequiredMessage
{
    _row = [JTRowDescriptor rowDescriptorWithTag:NSStringFromSelector(_cmd) rowType:JTFormRowTypeText title:NSStringFromSelector(_cmd)];
    _row.required = true;
    _row.requireMsg = @"请输入文字";
    [_form addRow:_row];
    
    NSArray *errors = [_form formValidationErrors];
    NSError *error= errors.firstObject;
    XCTAssertTrue([error.localizedDescription isEqualToString:_row.requireMsg]);
}

- (void)testRowRequired
{
    _row = [JTRowDescriptor rowDescriptorWithTag:NSStringFromSelector(_cmd) rowType:JTFormRowTypeText title:NSStringFromSelector(_cmd)];
    _row.required = true;
    [_form addRow:_row];
    _form.formDescriptor.addAsteriskToRequiredRowsTitle = true;
    
    [_row updateCell];
    XCTAssertTrue([_row.cellForDescriptor.titleNode.attributedText.string containsString:@"*"]);
    
    NSArray *errors = [_form formValidationErrors];
    NSError *error= errors.firstObject;
    XCTAssertEqual(error.userInfo[JTRowDescriptorErrorKey], _row);
}

- (void)testRowConfigDict
{
    NSAttributedString *attributeStringAfterUpdate = [NSAttributedString jt_attributedStringWithString:@"after update" font:nil color:nil];
    NSAttributedString *attributeStringWhenDisabled = [NSAttributedString jt_attributedStringWithString:@"when disabled" font:nil color:nil];
    
    JTRowDescriptor *row = [JTRowDescriptor rowDescriptorWithTag:@"testRowCellConfigDict" rowType:JTFormRowTypeInfo title:nil];
    [row.configAfterConfig setObject:@(UIEdgeInsetsMake(0., 20., 0., 0.)) forKey:@"separatorInset"];
    [row.configAfterUpdate setObject:attributeStringAfterUpdate forKey:@"titleNode.attributedText"];
    [row.configWhenDisabled setObject:attributeStringWhenDisabled forKey:@"titleNode.attributedText"];
    row.cellForDescriptor.accessibilityLabel = @"testRowCellConfigDict";
    [_form addRow:row];    
    XCTAssertTrue(row.cellForDescriptor.separatorInset.left == 20.);
        
    [tester waitForViewWithAccessibilityLabel:@"testRowCellConfigDict"];
    XCTAssertTrue([row.cellForDescriptor.titleNode.attributedText.string isEqualToString:@"after update"]);
    
    row.disabled = true;
    XCTAssertTrue([row.cellForDescriptor.titleNode.attributedText.string isEqualToString:@"when disabled"]);
}

- (void)testRowValueValidator
{
    _row = [_form findRowByTag:@"JTFormRowTypeEmail"];
    _row.required = true;
    _row.value = @"kikido@@gmail.com";
    [_row addValidator:[JTFormRegexValidator formRegexValidatorWithMsg:@"邮箱格式错误" regex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,11}"]];
    XCTAssertFalse([_row doValidate].valid);
    _row.value = @"kikido1992@gmail.com";
    XCTAssertTrue([_row doValidate].valid);
}

- (void)testTypeRowMaxNumberOfCharacters
{
    NSInteger maxNumberOfCharacters = 3;
    _row = [_form findRowByTag:@"JTFormRowTypeText"];
    _row.maxNumberOfCharacters = @(maxNumberOfCharacters);
    
    UIView *cell = [tester waitForViewWithAccessibilityLabel:@"JTFormRowTypeText"];
    [tester enterText:@"好好吃😊" intoElement:nil inView:cell expectedResult:@"好好吃"];
    [tester enterText:@"测试测试" intoElement:nil inView:cell expectedResult:@"测试测"];
    [tester enterText:@"去洗澡123" intoElement:nil inView:cell expectedResult:@"去洗澡"];
    
    _row = [_form findRowByTag:@"JTFormRowTypeDecimal"];
    _row.maxNumberOfCharacters = @(maxNumberOfCharacters);
    cell = [tester waitForViewWithAccessibilityLabel:@"JTFormRowTypeDecimal"];
    [tester enterText:@"111." intoElement:nil inView:cell expectedResult:@"111"];
    [tester enterText:@"1.11" intoElement:nil inView:cell expectedResult:@"1.11"];
}

- (void)testTextTypeRowFormatter
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterPercentStyle;

    _row = [_form findRowByTag:@"JTFormRowTypeDecimal"];
    _row.valueFormatter = formatter;
    
    UIView *cell = [tester waitForViewWithAccessibilityLabel:@"JTFormRowTypeDecimal"];
    [tester enterText:@"0.1" intoElement:nil inView:cell expectedResult:[formatter stringFromNumber:[NSDecimalNumber numberWithDouble:0.1]]];
}

- (void)testRowUpdateCell
{
    _row = [_form findRowByTag:@"JTFormRowTypeText"];
    _row.value = @"this is test";
     
    [_form.tableNode performBatchAnimated:YES updates:^{
        [_row updateCell];
    } completion:nil];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeInterval]];

}

- (void)testRowManualSetHeight
{
    CGFloat targetHeight = 400.;
    CGFloat separatorHeight = 1.0 / JTScreenScale();
    
    _row = [_form findRowByTag:@"JTFormRowTypeText"];
    _row.height = targetHeight;
     
    [_form.tableNode performBatchAnimated:YES updates:^{
        [_form reloadRows:@[_row]];
    } completion:^(BOOL finished) {
        CGRect frame = [_form.tableNode rectForRowAtIndexPath:[NSIndexPath indexPathForRow:NumberOfRows inSection:NumberOfSections - 1]];
        XCTAssertTrue(frame.size.height == targetHeight + separatorHeight);
    }];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeInterval]];
}

- (void)testRowChangeCellType
{
    _row = [_form findRowByTag:@"JTFormRowTypeText"];
    _row.value = @"juest test";
    
    [_form.tableNode performBatchAnimated:YES updates:^{
        [_row reloadCellWithNewRowType:JTFormRowTypeFloatText];
    } completion:^(BOOL finished) {
        XCTAssertTrue([_row.rowType isEqualToString:JTFormRowTypeFloatText]);
    }];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kWaitTimeInterval]];
}

- (void)testValueChangeBlock
{
    JTForm *form = _form;
    JTRowDescriptor *row;
    UIAccessibilityElement *element;
    NSMutableArray *expectations = [NSMutableArray array];
    XCTestExpectation *expetation;
    NSArray *options = [JTOptionObject optionObjectsWithOptionValues:@[@1, @2, @3] optionTexts:@[@"西瓜", @"桃子", @"香蕉"]];
    
    // text
    NSArray *textTags = @[@"JTFormRowTypeText", @"JTFormRowTypeName", @"JTFormRowTypeEmail", @"JTFormRowTypeNumber", @"JTFormRowTypeInteger", @"JTFormRowTypeDecimal", @"JTFormRowTypePassword", @"JTFormRowTypePhone", @"JTFormRowTypeURL", @"JTFormRowTypeFloatText", @"JTFormRowTypeTextView"];
    for (int i = 0; i < textTags.count; i++) {
        NSString *tag = textTags[i];
        row = [form findRowByTag:tag];
        UIView *cell = [tester waitForViewWithAccessibilityLabel:tag];
        expetation = [[XCTestExpectation alloc] initWithDescription:tag];
        [expectations addObject:expetation];

        if (![tag isEqualToString:JTFormRowTypeDecimal]) {
            row.valueChangeBlock = ^(id  _Nullable oldValue, id  _Nonnull newValue, JTRowDescriptor * _Nonnull sender) {
                XCTAssertTrue([newValue isEqualToString:tag]);
                [expetation fulfill];
            };
            [tester enterText:tag intoElement:nil inView:cell expectedResult:nil];
        } else {
            // decimal
            row.valueChangeBlock = ^(id  _Nullable oldValue, id  _Nonnull newValue, JTRowDescriptor * _Nonnull sender) {
                XCTAssertTrue([newValue doubleValue] == 20.0);
                [expetation fulfill];
            };
            [tester enterText:@"20.0只能输入小数" intoElement:nil inView:cell expectedResult:nil];
        }
        [cell resignFirstResponder];
    }

    // select type
    NSArray *selectTags = @[@"JTFormRowTypePushSelect", @"JTFormRowTypeMultipleSelect", @"JTFormRowTypeSheetSelect", @"JTFormRowTypeAlertSelect", @"JTFormRowTypePickerSelect"];
    for (int i = 0; i < selectTags.count; i++) {
        NSString *tag = selectTags[i];
        row = [form findRowByTag:tag];
        row.selectorOptions = options;

        expetation = [[XCTestExpectation alloc] initWithDescription:tag];
        [expectations addObject:expetation];
        row.valueChangeBlock = ^(id  _Nullable oldValue, id  _Nonnull newValue, JTRowDescriptor * _Nonnull sender) {
            if ([newValue isKindOfClass:[JTOptionObject class]]) {
                XCTAssertTrue([[newValue descriptionForForm] isEqualToString:@"西瓜"]);
                [expetation fulfill];
            } else if ([newValue isKindOfClass:[NSArray class]]) {
                newValue = [newValue firstObject];
                XCTAssertTrue([[newValue descriptionForForm] isEqualToString:@"西瓜"]);
                [expetation fulfill];
            }
        };
        [tester tapViewWithAccessibilityLabel:tag];

        if ([tag isEqualToString:JTFormRowTypePushSelect] || [tag isEqualToString:JTFormRowTypeMultipleSelect]) {
            // push select
            [tester waitForViewWithAccessibilityLabel:@"tableview"];
            [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"tableview"];
            if ([tag isEqualToString:JTFormRowTypeMultipleSelect]) {
                // 返回前一页
                [tester tapViewWithAccessibilityLabel:NSLocalizedString(@"Back", nil) traits:UIAccessibilityTraitButton];
            }
        } else {
            [tester waitForViewWithAccessibilityLabel:@"西瓜"];
            [tester tapViewWithAccessibilityLabel:@"西瓜"];
            if ([tag isEqualToString:JTFormRowTypePickerSelect]) {
                [row.cellForDescriptor resignFirstResponder];
            }
        }
    }
    
    // date
    if (@available(iOS 14.0, *)) {
        // FIXME: kif 还没有适配
        // iOS14 后使用了新样式
        // https://github.com/kif-framework/KIF/issues/1183
    } else {
        NSArray *dateTags = @[@"JTFormRowTypeDate", @"JTFormRowTypeTime", @"JTFormRowTypeDateTime", @"JTFormRowTypeCountDownTimer"];
        NSArray *dateValues = @[@[@"October", @"10", @"2020"], @[@"10", @"10", @"AM"], @[@"October 10", @"10", @"10", @"AM"], @[@"10", @"10"]];
        for (int i = 0; i < dateTags.count; i++) {
            NSString *tag = dateTags[i];
            row = [form findRowByTag:tag];
            expetation = [[XCTestExpectation alloc] initWithDescription:tag];
            [expectations addObject:expetation];
            row.valueChangeBlock = ^(id  _Nullable oldValue, id  _Nonnull newValue, JTRowDescriptor * _Nonnull sender) {
                [expetation fulfill];
            };

            [tester waitForViewWithAccessibilityLabel:tag];
            [tester tapViewWithAccessibilityLabel:tag];
            XCTAssertTrue([row.cellForDescriptor isFirstResponder]);

            UIDatePicker *datepicker = [row.cellForDescriptor valueForKey:@"datePicker"];
            [tester selectDatePickerValue:dateValues[i] fromPicker:[self _getDatePickerViewFromPicker:datepicker] withSearchOrder:KIFPickerSearchForwardFromStart];
            NSLog(@"date, idx: %d, value: %@", i, row.value);
        }
    }
    
    NSArray *otherTags = @[@"JTFormRowTypeSwitch", @"JTFormRowTypeCheck", @"JTFormRowTypeStepCounter", @"JTFormRowTypeSegmentedControl", @"JTFormRowTypeSlider"];
    for (int i = 0; i < otherTags.count; i++) {
        row = [form findRowByTag:otherTags[i]];
        row.selectorOptions = options;
        expetation = [[XCTestExpectation alloc] initWithDescription:otherTags[i]];
        [expectations addObject:expetation];
        row.valueChangeBlock = ^(id  _Nullable oldValue, id  _Nonnull newValue, JTRowDescriptor * _Nonnull sender) {
            [expetation fulfill];
        };
    }
    // switch
    row = [form findRowByTag:@"JTFormRowTypeSwitch"];
    UIView *switchView = [tester waitForViewWithAccessibilityLabel:@"JTFormRowTypeSwitch"];
    [tester waitForAccessibilityElement:&element view:nil withLabel:nil value:nil traits:UIAccessibilityTraitButton fromRootView:switchView tappable:true];
    [tester setSwitch:(UISwitch *)element element:nil On:true];
    XCTAssertTrue([row.value boolValue]);
    // check
    [tester tapViewWithAccessibilityLabel:@"JTFormRowTypeCheck"];
    // step counter
    row = [form findRowByTag:@"JTFormRowTypeStepCounter"];
    UIView *stepView = [tester waitForViewWithAccessibilityLabel:@"JTFormRowTypeStepCounter"];
    [tester waitForAccessibilityElement:&element view:nil withLabel:nil value:nil traits:UIAccessibilityTraitNone fromRootView:stepView tappable:true];
    [tester tapStepperWithAccessibilityElement:nil increment:KIFStepperDirectionIncrement inView:(UIStepper *)element];
    XCTAssertTrue(row.value != nil);
    // segment control
    UIView *segmentView = [tester waitForViewWithAccessibilityLabel:@"JTFormRowTypeSegmentedControl"];
    [tester waitForAccessibilityElement:&element view:nil withLabel:@"西瓜" value:nil traits:UIAccessibilityTraitNone fromRootView:segmentView tappable:true];
    [tester tapAccessibilityElement:element inView:(UIView *)element];
    // slider
    row = [form findRowByTag:@"JTFormRowTypeSlider"];
    UIView *sliderView = [tester waitForViewWithAccessibilityLabel:@"JTFormRowTypeSlider"];
    [tester waitForAccessibilityElement:&element view:nil withLabel:nil value:nil traits:UIAccessibilityTraitNone fromRootView:sliderView tappable:true];
    [tester setValue:.5 forSlider:(UISlider *)element];
    XCTAssertTrue([row.value doubleValue] == 0.5);

    [self waitForExpectations:expectations timeout:30.];
}

#pragma mark - helper

- (void)makeRowDescriptorBecomeFirstResponder:(JTRowDescriptor *)rowDescriptor
{
    XCTAssertNotNil(rowDescriptor);
    NSString *rowtype = rowDescriptor.rowType;
    
    NSArray *tags = @[@"JTFormRowTypeFloatText", @"JTFormRowTypeText", @"JTFormRowTypeName", @"JTFormRowTypeEmail", @"JTFormRowTypeNumber", @"JTFormRowTypeInteger", @"JTFormRowTypeDecimal", @"JTFormRowTypePassword", @"JTFormRowTypePhone", @"JTFormRowTypeURL", @"JTFormRowTypeTextView"];
    for (NSString *tag in tags) {
        if ([rowtype isEqualToString:tag]) {
            UIView *cell = [tester waitForViewWithAccessibilityLabel:tag];
            [tester enterText:@"1" intoElement:nil inView:cell expectedResult:nil];
            return;
        }
    }
    
    tags = @[@"JTFormRowTypeDate", @"JTFormRowTypeTime", @"JTFormRowTypeDateTime", @"JTFormRowTypeCountDownTimer", @"JTFormRowTypeDateInline", @"JTFormRowTypeTimeInline", @"JTFormRowTypeDateTimeInline", @"JTFormRowTypeCountDownTimerInline"];
    for (NSString *tag in tags) {
        if ([rowtype isEqualToString:tag]) {
            NSIndexPath *indexpath = [_form indexPathForRow:rowDescriptor];
            [tester tapRowAtIndexPath:indexpath inTableView:_form.tableView];
            return;
        }
    }
}

- (BOOL)compareColor:(UIColor *)fromColor toColor:(UIColor *)toColor
{
    if (!fromColor || !toColor) {
        return false;
    }
    return CGColorEqualToColor(fromColor.CGColor, toColor.CGColor);
}

- (UIPickerView *)_getDatePickerViewFromPicker:(UIView *)picker
{
    for (UIView *view in picker.subviews) {
        if ([NSStringFromClass([view class]) hasPrefix:@"_UIDatePickerView"]) {
            return (UIPickerView *) view;
        }
    }
    return nil;
}

CGFloat JTScreenScale()
{
  static CGFloat __scale = 0.0;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), YES, 0);
    __scale = CGContextGetCTM(UIGraphicsGetCurrentContext()).a;
    UIGraphicsEndImageContext();
  });
  return __scale;
}

@end
