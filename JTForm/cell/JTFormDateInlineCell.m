//
//  JTFormDateInlineCell.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTFormDateInlineCell.h"

@implementation JTFormDateInlineCell {
    JTRowDescriptor *_toRow;
}

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
    
    if (self.rowDescriptor.value) {
        if (formatter) {
            NSAssert([formatter isKindOfClass:[NSDateFormatter class]],
                     @"valueFormatter is not subclass of NSDateFormatter");
            displayContent = [(NSDateFormatter *)formatter stringFromDate:self.rowDescriptor.value];
        }
        else {
            if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeCountDownTimerInline]) {
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
    NSDateFormatter *dateFormatter = nil;
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

- (void)formCellDidSelected
{
    if (!self.rowDescriptor.disabled) {
        if (!self.hasInlineCell && !_toRow) {
            [self showConnectedCell];
        } else if (self.hasInlineCell && _toRow) {
            [self hideConnectedCell];
        } else {
            // do nothing
        }
    }
}

- (void)showConnectedCell
{
    self.hasInlineCell = YES;
    
    if (!self.rowDescriptor.value) {
        [self.rowDescriptor manualSetValue:[NSDate date]];
        self.contentNode.attributedText = [self _cellDisplayContent];
    }
    // insert inline row
    JTRowDescriptor *inlineRow = [JTRowDescriptor rowDescriptorWithTag:nil
                                                               rowType:[JTForm inlineRowTypesForRowTypes][self.rowDescriptor.rowType]
                                                                 title:nil];
    JTBaseCell<JTFormInlineCellDelegate> *inlineCell = (JTBaseCell<JTFormInlineCellDelegate> *)[inlineRow cellForDescriptor];
    NSAssert([inlineCell conformsToProtocol:@protocol(JTFormInlineCellDelegate)],
             @"inline cell must conform to protocol 'JTFormInlineCellDelegate'");
    inlineCell.connectedRowDescriptor = self.rowDescriptor;
    // 先使用 -updateCell 方法填充好内容，直接计算出布局
    [inlineCell update];

    [[self findForm] addRows:@[inlineRow] afterRow:self.rowDescriptor];
    [inlineCell onDidLoad:^(__kindof ASDisplayNode * _Nonnull node) {
        [[self findForm] ensureRowIsVisible:inlineRow];
    }];
    [self.findForm beginEditing:self.rowDescriptor];
    _toRow = inlineRow;
}

- (void)hideConnectedCell
{
    self.hasInlineCell = NO;
    [self.rowDescriptor.sectionDescriptor removeRow:_toRow];
    _toRow = nil;
    [self.findForm endEditing:self.rowDescriptor];
}

#pragma mark - responder

- (BOOL)canBecomeFirstResponder
{
    return false;
}

- (BOOL)isFirstResponder
{
    return false;
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    if (_toRow && self.hasInlineCell) {
        // @1
        // 如果使用 firstRespinder 来控制 inlinecell 的显示与隐藏，在滑动时，由于复用 cell ，会调用该 node 的 resignFirstResponder 方法
        // 如果直接调用 hideConnectedCell 方法，会导致数据源中的单元行数目与实际单元行数目不一致崩溃
        // 通过调试发现是调用 endupdates 后没有重新调用 numberOfRowsInSection 方法刷新单元行数目
        
        // @2
        // 综合考虑，使用属性 hasInlineCell 来控制 inline 的显示与隐藏，避免在滑动时 inline cell 的自动隐藏造成的其它错误
        // 所以该方法最好在别的方法里调用，但为了方便，所以我偷个懒写在这里
        [self hideConnectedCell];
    }
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
@property (nonatomic, strong, readonly) UIDatePicker *datePicker;
@property (nonatomic, strong) ASDisplayNode *datePickerNode;
@end

@implementation _JTFormDateInlineCell

NSString * const _JTFormRowTypeDateInline = @"_JTFormRowTypeDateInline";

@synthesize connectedRowDescriptor = _connectedRowDescriptor;

+ (void)load
{
    [[JTForm cellClassesForRowTypes]    setObject:[_JTFormDateInlineCell class] forKey:_JTFormRowTypeDateInline];
    [[JTForm inlineRowTypesForRowTypes] setObject:_JTFormRowTypeDateInline forKey:JTFormRowTypeDateInline];
    [[JTForm inlineRowTypesForRowTypes] setObject:_JTFormRowTypeDateInline forKey:JTFormRowTypeTimeInline];
    [[JTForm inlineRowTypesForRowTypes] setObject:_JTFormRowTypeDateInline forKey:JTFormRowTypeDateTimeInline];
    [[JTForm inlineRowTypesForRowTypes] setObject:_JTFormRowTypeDateInline forKey:JTFormRowTypeCountDownTimerInline];
}

- (void)config
{
    [super config];
    
    _datePickerNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.backgroundColor = [UIColor whiteColor];
        return datePicker;
    }];
}

- (void)update
{
    [super update];
    
    UIDatePicker *datePicker = (UIDatePicker *)_datePickerNode.view;
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    _datePicker = datePicker;
    [self setConfigToDatePicker];
    
    if (_connectedRowDescriptor.value) {
        [datePicker setDate:_connectedRowDescriptor.value animated:NO];
    } else {
        _connectedRowDescriptor.value = datePicker.date;
    }
    [datePicker sizeToFit];
    self.datePickerNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(datePicker.frame.size.width), ASDimensionMake(datePicker.frame.size.height));
    [self setNeedsLayout];
}

- (void)setConfigToDatePicker
{
    JTFormDateInlineCell *connectCell = (JTFormDateInlineCell *)[self.connectedRowDescriptor cellForDescriptor];
    if ([_connectedRowDescriptor.rowType isEqualToString:JTFormRowTypeDateInline]) {
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
    else if ([_connectedRowDescriptor.rowType isEqualToString:JTFormRowTypeTimeInline]) {
        _datePicker.datePickerMode = UIDatePickerModeTime;
    }
    else if ([_connectedRowDescriptor.rowType isEqualToString:JTFormRowTypeCountDownTimerInline]) {
        _datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    }
    else {
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    
    if (connectCell.minuteInterval) _datePicker.minuteInterval = [connectCell.minuteInterval integerValue];
    if (connectCell.minimumDate)    _datePicker.minimumDate    = connectCell.minimumDate;
    if (connectCell.maximumDate)    _datePicker.maximumDate    = connectCell.maximumDate;
    if (connectCell.locale)         _datePicker.locale         = connectCell.locale;
    
    
    if (@available(iOS 14.0, *)) {
        _datePicker.preferredDatePickerStyle = [_connectedRowDescriptor.rowType isEqualToString:JTFormRowTypeCountDownTimerInline] ? UIDatePickerStyleWheels : UIDatePickerStyleInline;
    } else {
        if ([_datePicker respondsToSelector:@selector(preferredDatePickerStyle)]) {
            _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        }
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    if (!_datePicker) {
        ASDisplayNode *node = [[ASDisplayNode alloc] init];
        node.style.layoutPosition = CGPointZero;
        node.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(0.), ASDimensionMake(0.));
        return [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:@[node]];
    }
    ASStackLayoutSpec *stack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                       spacing:0.
                                                                justifyContent:ASStackLayoutJustifyContentCenter
                                                                    alignItems:ASStackLayoutAlignItemsCenter
                                                                      children:@[_datePickerNode]];
    
    stack.style.flexGrow = 1.;
    stack.style.flexShrink = 1.;
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(12., 0., 12., 0.) child:stack];
}

#pragma mark - action

- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    if (self.connectedRowDescriptor) {
        [self.connectedRowDescriptor manualSetValue:sender.date];
        [self.connectedRowDescriptor updateCell];
    }
}

@end
