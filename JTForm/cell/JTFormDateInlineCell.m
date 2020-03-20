//
//  JTFormDateInlineCell.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTFormDateInlineCell.h"


@implementation JTFormDateInlineCell

- (void)config
{
    [super config];
}

- (void)update
{
    [super update];
  
    self.contentNode.attributedText = [self _cellDisplayContent];
}



- (NSAttributedString *)_cellDisplayContent
{
    BOOL noValue = false;
    NSString *displayContent = nil;
    NSFormatter *formatter = [self _dateFormatterForRowType:self.rowDescriptor.rowType];
    
    if (self.rowDescriptor.value)
    {
        if (formatter)
        {
            NSAssert([formatter isKindOfClass:[NSDateFormatter class]],
                     @"valueFormatter is not subclass of NSDateFormatter");
            displayContent = [(NSDateFormatter *)formatter stringFromDate:self.rowDescriptor.value];
        }
        else
        {
            if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeCountDownTimerInline]) {
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

- (NSFormatter *)_dateFormatterForRowType:(NSString *)rowType
{
    if (self.rowDescriptor.valueFormatter) {
        return self.rowDescriptor.valueFormatter;
    }
    NSDateFormatter *dateFormatter;
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeDateInline]) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    } else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeTimeInline]) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterNoStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
    } else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeDateTimeInline]) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    return dateFormatter;
}

#pragma mark - responder

- (BOOL)cellCanBecomeFirstResponder
{
    return !self.rowDescriptor.disabled;
}

- (BOOL)cellBecomeFirstResponder
{
    if ([self isFirstResponder]) {
        return [self resignFirstResponder];
    } else {
        if (!self.rowDescriptor.value) {
            self.rowDescriptor.value = [NSDate date];
            self.contentNode.attributedText = [self _cellDisplayContent];
        }
        return [self becomeFirstResponder];
    }
}

- (BOOL)canBecomeFirstResponder
{
    [super canBecomeFirstResponder];
    return true;
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    
    NSIndexPath *currentIndexPath = [[self findForm] indexPathForRow:self.rowDescriptor];
    JTSectionDescriptor *section = [[self findForm] sectionAtIndex:currentIndexPath.section];
    JTRowDescriptor *inlineRow = [JTRowDescriptor rowDescriptorWithTag:nil
                                                               rowType:[JTForm inlineRowTypesForRowTypes][JTFormRowTypeDateInline]
                                                                 title:nil];
    JTBaseCell<JTFormInlineCellDelegate> *inlineCell = (JTBaseCell<JTFormInlineCellDelegate> *)[inlineRow cellInForm];
    
    NSAssert([inlineCell conformsToProtocol:@protocol(JTFormInlineCellDelegate)],
             @"inline cell must conform to protocol 'JTFormInlineCellDelegate'");
    inlineCell.connectedRowDescriptor = self.rowDescriptor;
    
    [section addRow:inlineRow afterRow:self.rowDescriptor];
    [[self findForm] ensureRowIsVisible:inlineRow];
    [self.findForm beginEditing:self.rowDescriptor];
    
    return true;
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    
    NSIndexPath *currentIndexPath = [[self findForm] indexPathForRow:self.rowDescriptor];
    NSIndexPath *nextRowPath = [NSIndexPath indexPathForRow:currentIndexPath.row + 1 inSection:currentIndexPath.section];
    JTRowDescriptor *inlineRow = [self.rowDescriptor.sectionDescriptor.formDescriptor rowAtIndexPath:nextRowPath];
    if ([inlineRow.rowType isEqualToString:[JTForm inlineRowTypesForRowTypes][JTFormRowTypeDateInline]]) {
        [self.rowDescriptor.sectionDescriptor removeRow:inlineRow];
    }
    [self.findForm endEditing:self.rowDescriptor];

    return true;
}

#pragma mark - layout

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    NSArray *leftChildren = self.imageNode.hasContent ? @[self.imageNode, self.titleNode] : @[self.titleNode];
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
@end

/**
 * 关联行
 */
@interface _JTFormDateInlineCell : JTBaseCell <JTFormInlineCellDelegate>
@property (nonatomic, strong) UIDatePicker  *datePicker;
@property (nonatomic, strong) ASDisplayNode *datePickerNode;
@end

@implementation _JTFormDateInlineCell

NSString * const _JTFormRowTypeDateInline = @"_JTFormRowTypeDateInline";

@synthesize connectedRowDescriptor = _connectedRowDescriptor;

+ (void)load
{
    [[JTForm cellClassesForRowTypes] setObject:[_JTFormDateInlineCell class] forKey:_JTFormRowTypeDateInline];
    [[JTForm inlineRowTypesForRowTypes] setObject:_JTFormRowTypeDateInline forKey:JTFormRowTypeDateInline];
    [[JTForm inlineRowTypesForRowTypes] setObject:_JTFormRowTypeDateInline forKey:JTFormRowTypeTimeInline];
    [[JTForm inlineRowTypesForRowTypes] setObject:_JTFormRowTypeDateInline forKey:JTFormRowTypeDateTimeInline];
    [[JTForm inlineRowTypesForRowTypes] setObject:_JTFormRowTypeDateInline forKey:JTFormRowTypeCountDownTimerInline];
}

- (void)config
{
    [super config];
    
    __weak typeof(self) weakSelf = self;
    _datePickerNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.backgroundColor = [UIColor whiteColor];
        [datePicker addTarget:strongSelf action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        return datePicker;
    }];
}

- (void)update
{
    [super update];
    
    _datePicker = (UIDatePicker *)_datePickerNode.view;
    if (_connectedRowDescriptor.value) {
        [_datePicker setDate:_connectedRowDescriptor.value animated:NO];
    }
    JTFormDateInlineCell *connectCell = (JTFormDateInlineCell *)[self.connectedRowDescriptor cellInForm];
    if (connectCell.minimumDate)    _datePicker.minimumDate = connectCell.minimumDate;
    if (connectCell.maximumDate)    _datePicker.maximumDate = connectCell.maximumDate;
    if (connectCell.locale)         _datePicker.locale = connectCell.locale;
    
    if ([_connectedRowDescriptor.rowType isEqualToString:JTFormRowTypeDateInline]) {
        _datePicker.datePickerMode = UIDatePickerModeDate;
    } else if ([_connectedRowDescriptor.rowType isEqualToString:JTFormRowTypeTimeInline]) {
        _datePicker.datePickerMode = UIDatePickerModeTime;
    } else if ([_connectedRowDescriptor.rowType isEqualToString:JTFormRowTypeCountDownTimerInline]) {
        _datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
//        _datePicker.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    } else {
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
}

+ (CGFloat)formCellHeightForRowDescriptor:(JTRowDescriptor *)row
{
    return kJTFormDateInlineDateHeight;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    _datePickerNode.style.alignSelf = ASStackLayoutAlignSelfStretch;
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero child:_datePickerNode];
}

#pragma mark - action

- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    if (self.connectedRowDescriptor) {
        self.connectedRowDescriptor.value = sender.date;
        [self.findForm updateRow:self.connectedRowDescriptor];
    }
}
@end
