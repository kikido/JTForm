//
//  JTFormDateCell.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTFormDateCell.h"

@interface JTFormDateCell () <ASEditableTextNodeDelegate>
/**
 * 辅助 node
 *
 * @discuss 因为不知道怎么在 cellNode 上面替换自定义的键盘 `inputView`,
 * 所以使用该属性。用 ASEditableTextNode 来充当第一响应者，然后在开始编辑的时候替换成自己的 inputView
 */
@property (nonatomic, strong) ASEditableTextNode *tempNode;
@property (nonatomic, strong, readonly) UIDatePicker *datePicker;
@end

@implementation JTFormDateCell

- (void)config
{
    [super config];
    
    _tempNode                     = [[ASEditableTextNode alloc] init];
    _tempNode.delegate            = self;
    _tempNode.scrollEnabled       = false;
    _tempNode.style.preferredSize = CGSizeMake(0.01, 0.01);
}

- (void)update
{
    [super update];
    
    _tempNode.textView.editable     = !self.rowDescriptor.disabled;
    _tempNode.textView.inputView    = [self jtFormCellInputView];
    self.contentNode.attributedText = [self _cellDisplayContent];
}

#pragma mark - responder

- (BOOL)canBecomeFirstResponder
{
    return !self.rowDescriptor.disabled;
}

- (BOOL)becomeFirstResponder
{
    if (![self canBecomeFirstResponder]) {
        return false;
    }
    if (!self.rowDescriptor.value) {
        [self.rowDescriptor manualSetValue:[NSDate date]];
        self.contentNode.attributedText = [self _cellDisplayContent];
    }
    return [_tempNode becomeFirstResponder];
}

- (BOOL)isFirstResponder
{
    return [_tempNode isFirstResponder];
}

- (BOOL)canResignFirstResponder
{
    return [_tempNode canResignFirstResponder];
}

- (BOOL)resignFirstResponder
{
    if ([self canResignFirstResponder]) {
        return [_tempNode resignFirstResponder];
    }
    return false;
}

#pragma mark - layout

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    NSArray *leftChildren = self.imageNode.hasContent ? @[self.imageNode, self.titleNode, self.tempNode] : @[self.titleNode, self.tempNode];
    ASStackLayoutSpec *leftStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                           spacing:kJTFormCellImageSpace
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsCenter
                                                                          children:leftChildren];
    
    self.titleNode.style.maxHeight = ASDimensionMake(kJTFormDateMaxTitleHeight);
    self.titleNode.style.flexShrink = 2.;
    
    leftStack.style.flexShrink = 2.;
    
    self.contentNode.style.minWidth = ASDimensionMakeWithFraction(kJTFormDateMaxContentWidthFraction);
    self.contentNode.style.maxHeight = ASDimensionMake(kJTFormDateMaxContentHeight);
    self.contentNode.style.flexGrow = 1.;
    
    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                              spacing:15.
                                                                       justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                           alignItems: ASStackLayoutAlignItemsCenter
                                                                             children:@[leftStack, self.contentNode]];
    contentStack.style.minHeight = ASDimensionMake(30.);
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(12., 15., 12., 15.) child:contentStack];
}

#pragma mark - helper

- (NSAttributedString *)_cellDisplayContent
{
    BOOL noValue = false;
    NSString *displayContent = nil;
    NSFormatter *formatter = [self _dateFormatterForRowType:self.rowDescriptor.rowType];
    
    if (self.rowDescriptor.value) {
        if (formatter) {
            NSAssert([formatter isKindOfClass:[NSDateFormatter class]],
                     @"valueFormatter is not subclass of NSDateFormatter");
            displayContent = [(NSDateFormatter *)formatter stringFromDate:self.rowDescriptor.value];
        }
        else {
            if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeCountDownTimer]) {
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDateComponents *time = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:self.rowDescriptor.value];
                displayContent = [NSString stringWithFormat:@"%ld%@ %ldmin", (long)[time hour], (long)[time hour] == 1 ? @"hour" : @"hours", (long)[time minute]];
            } else {
                displayContent = [self.rowDescriptor.value description];
            }
        }
    }
    else {
        noValue = YES;
        displayContent = self.rowDescriptor.placeHolder;
    }
    UIFont *font = noValue ? [self cellPlaceHolerFont] : [self cellContentFont];
    UIColor *color = noValue ? [self cellPlaceHolerColor] : [self cellContentColor];
    
    return [NSAttributedString jt_rightAttributedStringWithString:displayContent
                                                             font:font
                                                            color:color];
}

- (NSFormatter *)_dateFormatterForRowType:(NSString *)rowType
{
    if (self.rowDescriptor.valueFormatter) {
        return self.rowDescriptor.valueFormatter;
    }
    NSDateFormatter *dateFormatter;
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeDate]) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    } else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeTime]) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterNoStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
    } else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeDateTime]) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    return dateFormatter;
}

- (UIView *)jtFormCellInputView
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        if (@available(iOS 14.0, *)) {
            _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        }
        [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    }

    [self setConfigToDatePicker];
    if (self.rowDescriptor.value) {
        [_datePicker setDate:self.rowDescriptor.value animated:NO];
    }
    return _datePicker;
}

- (void)setConfigToDatePicker
{
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeDate]) {
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeTime]) {
        _datePicker.datePickerMode = UIDatePickerModeTime;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeCountDownTimer]) {
        _datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    }
    else {
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    
    if (self.minuteInterval) _datePicker.minuteInterval = [self.minuteInterval integerValue];
    if (self.minimumDate)    _datePicker.minimumDate = self.minimumDate;
    if (self.maximumDate)    _datePicker.maximumDate = self.maximumDate;
    if (self.locale)         _datePicker.locale = self.locale;
}

#pragma mark - action

- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    [self.rowDescriptor manualSetValue:sender.date];
    self.contentNode.attributedText = [self _cellDisplayContent];
}

#pragma mark - ASEditableTextNodeDelegate

- (BOOL)editableTextNodeShouldBeginEditing:(ASEditableTextNode *)editableTextNode
{
    return [self canBecomeFirstResponder];
}

- (void)editableTextNodeDidBeginEditing:(ASEditableTextNode *)editableTextNode
{
    [self.findForm beginEditing:self.rowDescriptor];
}

- (void)editableTextNodeDidFinishEditing:(ASEditableTextNode *)editableTextNode
{
    [self.findForm endEditing:self.rowDescriptor];
}

@end
