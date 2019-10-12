//
//  JTFormDateCell.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTFormDateCell.h"
#import "JTFormDateInlineCell.h"

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
    
    _datePicker = [[UIDatePicker alloc] init];
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)update
{
    [super update];
    
    if (!self.rowDescriptor.valueFormatter) {
        // 除了 JTFormRowTypeCountDownTimer，其它几种如果没有给定的 valueFormatter 则赋值一个
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeDate])
        {
            dateFormatter.dateFormat = @"yyyy-MM-dd";
            self.rowDescriptor.valueFormatter = dateFormatter;
        }
        else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeTime])
        {
            dateFormatter.dateStyle = NSDateFormatterNoStyle;
            dateFormatter.timeStyle = NSDateFormatterShortStyle;
            self.rowDescriptor.valueFormatter = dateFormatter;
        }
        else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeDateTime])
        {
            dateFormatter.dateStyle = NSDateFormatterShortStyle;
            dateFormatter.timeStyle = NSDateFormatterShortStyle;
            self.rowDescriptor.valueFormatter = dateFormatter;
        }
    }
    _tempNode.textView.editable     = !self.rowDescriptor.disabled;
    self.contentNode.attributedText = [self _cellDisplayContent];
}

#pragma mark - responder

- (BOOL)cellCanBecomeFirstResponder
{
    return !self.rowDescriptor.disabled;
}

- (BOOL)cellBecomeFirstResponder
{
    if (!self.rowDescriptor.value) {
        self.rowDescriptor.value = [NSDate date];
        self.contentNode.attributedText = [self _cellDisplayContent];
    }
    return [_tempNode becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    [super canBecomeFirstResponder];
    return !self.rowDescriptor.disabled;
}

- (BOOL)isFirstResponder
{
    [super isFirstResponder];
    return [_tempNode isFirstResponder];
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    return [_tempNode resignFirstResponder];
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
    
    if (self.rowDescriptor.value)
    {
        if (self.rowDescriptor.valueFormatter)
        {
            NSAssert([self.rowDescriptor.valueFormatter isKindOfClass:[NSDateFormatter class]],
                     @"valueFormatter is not subclass of NSDateFormatter");
            displayContent = [(NSDateFormatter *)self.rowDescriptor.valueFormatter stringFromDate:self.rowDescriptor.value];
        }
        else
        {
            if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeCountDownTimer]) {
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDateComponents *time = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:self.rowDescriptor.value];
                displayContent = [NSString stringWithFormat:@"%ld%@ %ldmin", (long)[time hour], (long)[time hour] == 1 ? @"hour" : @"hours", (long)[time minute]];
            } else {
                displayContent = [self.rowDescriptor.value description];
            }
        }
    }
    else
    {
        noValue = YES;
        displayContent = self.rowDescriptor.placeHolder;
    }
    UIFont *font = noValue ? [self cellPlaceHolerFont] : [self cellContentFont];
    UIColor *color = noValue ? [self cellPlaceHolerColor] : [self cellContentColor];
    
    return [NSAttributedString jt_rightAttributedStringWithString:displayContent
                                                             font:font
                                                            color:color];
}

- (UIView *)jtFormCellInputView
{
    if (self.rowDescriptor.value) {
        [self.datePicker setDate:self.rowDescriptor.value animated:[self.rowDescriptor.rowType isEqualToString:JTFormRowTypeCountDownTimer]];
    }
    [self setConfigToDatePicker];
    return self.datePicker;
}

- (void)setConfigToDatePicker
{
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeDate])
    {
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeTime])
    {
        _datePicker.datePickerMode = UIDatePickerModeTime;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeCountDownTimer])
    {
        _datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        _datePicker.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    }
    else
    {
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
    self.rowDescriptor.value = sender.date;
    self.contentNode.attributedText = [self _cellDisplayContent];
}

#pragma mark - ASEditableTextNodeDelegate

- (BOOL)editableTextNodeShouldBeginEditing:(ASEditableTextNode *)editableTextNode
{
    [self.findForm beginEditing:self.rowDescriptor];
    editableTextNode.textView.inputView = [self jtFormCellInputView];
    return true;
}

- (void)editableTextNodeDidFinishEditing:(ASEditableTextNode *)editableTextNode
{
    [self.findForm endEditing:self.rowDescriptor];
}
@end
