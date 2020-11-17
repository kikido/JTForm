//
//  FormOneController.m
//  JTFormDemo
//
//  Created by dqh on 2019/6/12.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "FormOneController.h"

@interface NSDictionary (JTLog)
@end

@implementation NSDictionary (JTLog)
- (NSString *)description
{
    __block BOOL otherClass = false;
    [self.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self js_otherClass:obj]) {
            otherClass = YES;
            *stop = YES;
        }
    }];
    NSString *jsonString;
    if (otherClass) {
        jsonString = [super description];
    } else {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (NSString *)debugDescription
{
    return [self description];
}

- (NSString *)descriptionWithLocale:(id)locale
{
    return [self description];
}

- (BOOL)js_otherClass:(id)object
{
    if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSIndexSet class]] || [object isKindOfClass:[NSNull class]]) {
        return NO;
    }
    return YES;
}
@end

@interface FormOneController () <UITextFieldDelegate>
@end

@implementation FormOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JTFormDescriptor *formDescriptor = [JTFormDescriptor formDescriptor];
    formDescriptor.addAsteriskToRequiredRowsTitle = YES;
    JTSectionDescriptor *section = nil;
    JTRowDescriptor *row = nil;

    NSArray *tags = @[@"JTFormRowTypeFloatText", @"JTFormRowTypeText", @"JTFormRowTypeName", @"JTFormRowTypeEmail", @"JTFormRowTypeNumber", @"JTFormRowTypeInteger", @"JTFormRowTypeDecimal", @"JTFormRowTypePassword", @"JTFormRowTypePhone", @"JTFormRowTypeURL", @"JTFormRowTypeInfo",
                      @"JTFormRowTypeTextView", @"JTFormRowTypeLongInfo",
                      @"JTFormRowTypePushSelect", @"JTFormRowTypeMultipleSelect", @"JTFormRowTypeSheetSelect", @"JTFormRowTypeAlertSelect", @"JTFormRowTypePickerSelect", @"JTFormRowTypePushButton",
                      @"JTFormRowTypeDate", @"JTFormRowTypeTime", @"JTFormRowTypeDateTime", @"JTFormRowTypeCountDownTimer", @"JTFormRowTypeDateInline", @"JTFormRowTypeTimeInline", @"JTFormRowTypeDateTimeInline", @"JTFormRowTypeCountDownTimerInline",
                      @"JTFormRowTypeSwitch", @"JTFormRowTypeCheck", @"JTFormRowTypeStepCounter", @"JTFormRowTypeSegmentedControl", @"JTFormRowTypeSlider"];
    
    section = [JTSectionDescriptor formSection];
    section.headerHeight = 40.;
    section.headerAttributedString = [NSAttributedString jt_attributedStringWithString:@"header view" font:nil color:nil];
    section.footerHeight = 40.;
    section.footerAttributedString = [NSAttributedString jt_attributedStringWithString:@"footer view" font:nil color:nil];
    [formDescriptor addSection:section];
    
    NSArray *dateTags = @[@"JTFormRowTypeDate", @"JTFormRowTypeTime", @"JTFormRowTypeDateTime"];
    NSArray *inlineDateTags = @[@"JTFormRowTypeDate", @"JTFormRowTypeTime", @"JTFormRowTypeDateTime"];
    NSArray *options = [JTOptionObject optionObjectsWithOptionValues:@[@1, @2, @3, @4, @5] optionTexts:@[@"西瓜", @"桃子", @"香蕉", @"橘子", @"柿子"]];
    
    for (NSInteger i = 0; i < tags.count; i++) {
        NSString *tag = tags[i];
        row = [JTRowDescriptor rowDescriptorWithTag:tags[i] rowType:tags[i] title:tags[i]];
        row.cellForDescriptor.accessibilityLabel = tags[i];
        row.selectorOptions = options;
        [section addRow:row];
        
        if (@available(iOS 14.0, *)) {
            for (NSString *dateTag in dateTags) {
                if ([dateTag isEqualToString:tag]) {
                    row.configAfterUpdate[@"datePickerNode.accessibilityLabel"] = [NSString stringWithFormat:@"%@-datepicker", tag];
                }
            }
        } else {
            for (NSString *dateTag in dateTags) {
                if ([dateTag isEqualToString:tag]) {
                    row.configAfterUpdate[@"datePicker.accessibilityLabel"] = [NSString stringWithFormat:@"%@-datepicker", tag];
                    row.configAfterUpdate[@"datePicker.locale"] = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
                }
            }
        }
    }
   
    
    JTForm *form = [[JTForm alloc] initWithDescriptor:formDescriptor];
    form.frame = CGRectMake(0, 0, kJTScreenWidth, kJTScreenHeight-64.);
    form.accessibilityLabel = @"form";
    [self.view addSubview:form];
    self.form = form;
    form.tableNode.displaysAsynchronously = false;
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
