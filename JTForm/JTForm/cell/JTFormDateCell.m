//
//  JTFormDateCell.m
//  JTForm
//
//  Created by dqh on 2019/4/25.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTFormDateCell.h"
#import "JTFormDateInlineCell.h"

@interface JTFormDateCell () <ASEditableTextNodeDelegate>
/** 因为实在不知道怎么替换当前view的‘inputView’属性，所以当类型为‘JTFormRowTypePickerSelect’时，只能让这个属性成为第一响应者，然后用‘pickerView’属性替换掉它的‘textview.inputView’ */
@property (nonatomic, strong) ASEditableTextNode *tempNode;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation JTFormDateCell

- (void)config
{
    [super config];
    
    _tempNode = [[ASEditableTextNode alloc] init];
    _tempNode.delegate = self;
    _tempNode.scrollEnabled = false;
    _tempNode.backgroundColor = [UIColor purpleColor];
    _tempNode.style.preferredSize = CGSizeMake(0.01, 0.01);
    
    self.titleNode.backgroundColor = [UIColor blueColor];
}

- (void)update
{
    [super update];
    
    BOOL required = self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle;
    self.titleNode.attributedText = [NSAttributedString
                                     attributedStringWithString:[NSString stringWithFormat:@"%@%@",required ? @"*" : @"", self.rowDescriptor.title]
                                     font:self.rowDescriptor.disabled ? [self formCellDisabledTitleFont] : [self formCellTitleFont]
                                     color:self.rowDescriptor.disabled ? [self formCellDisabledTitleColor] : [self formCellTitleColor]
                                     firstWordColor:required ? kJTFormRequiredCellFirstWordColor : nil];
    
    if (!self.rowDescriptor.valueFormatter) {
        self.rowDescriptor.valueFormatter = [[NSDateFormatter alloc] init];
    }
    _dateFormatter = (NSDateFormatter *)self.rowDescriptor.valueFormatter;
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeDate]) {
        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeTime]) {
        _dateFormatter.dateStyle = NSDateFormatterNoStyle;
        _dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    else {
        _dateFormatter.dateStyle = NSDateFormatterShortStyle;
        _dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    self.contentNode.attributedText = [self cellDisplayContent];
}

- (void)formCellDidSelected
{
//     [[[self jtForm] tableNode] deselectRowAtIndexPath:[self.rowDescriptor.sectionDescriptor.formDescriptor indexPathForRowDescriptor:self.rowDescriptor] animated:YES];
}

- (BOOL)formCellCanBecomeFirstResponder
{
    return !self.rowDescriptor.disabled;
}

- (BOOL)formCellBecomeFirstResponder
{
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeDateInline]) {
        NSIndexPath *currentIndexPath = [self.rowDescriptor.sectionDescriptor.formDescriptor indexPathForRowDescriptor:self.rowDescriptor];
        JTSectionDescriptor *section = [self.rowDescriptor.sectionDescriptor.formDescriptor.formSections objectAtIndex:currentIndexPath.section];
        JTRowDescriptor *inlineRow = [JTRowDescriptor formRowDescriptorWithTag:nil rowType:JTFormRowTypeInlineDatePicker title:nil];
        JTFormDateInlineCell *inlineCell = (JTFormDateInlineCell *)[inlineRow cellInForm];

        if (self.rowDescriptor.value) {
            [inlineCell.datePicker setDate:self.rowDescriptor.value animated:NO];
        }
        NSAssert([inlineCell conformsToProtocol:@protocol(JTFormInlineCellDelegate)], @"inline cell must conform to protocol 'JTFormInlineCellDelegate'");
        inlineCell.connectedRowDescriptor = self.rowDescriptor;
        
        [section addFormRow:inlineRow afterRow:self.rowDescriptor];
//        [self.form ensureRowIsVisible:datePickerRowDescriptor];
        
        return YES;
    }
    return [_tempNode becomeFirstResponder];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    NSArray *leftChildren = self.imageNode.image ? (_tempNode ? @[self.imageNode, self.titleNode, _tempNode] : @[self.imageNode, self.titleNode]) : (_tempNode ? @[self.titleNode, _tempNode] : @[self.titleNode]);
    ASStackLayoutSpec *leftStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                           spacing:10.
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsStart
                                                                          children:leftChildren];
    
    self.titleNode.style.maxHeight = ASDimensionMake(kJTFormDateMaxTitleHeight);
    self.titleNode.style.flexShrink = 2.;
    
    
    leftStack.style.flexShrink = 2.;
    
    
    
    self.contentNode.style.minWidth = ASDimensionMakeWithFraction(kJTFormDateMaxContentWidthFraction);
    self.contentNode.style.maxHeight = ASDimensionMake(kJTFormDateMaxContentHeight);
    self.contentNode.style.flexGrow = 2.;
    
    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                              spacing:15.
                                                                       justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                           alignItems: ASStackLayoutAlignItemsCenter
                                                                             children:@[leftStack, self.contentNode]];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15., 15., 15., 15.) child:contentStack];
}

#pragma mark - helper

- (NSAttributedString *)cellDisplayContent
{
    BOOL noValue = false;
    NSString *displayContent = nil;
    
    if (self.rowDescriptor.value) {
        if (_dateFormatter) {
            NSAssert([_dateFormatter isKindOfClass:[NSDateFormatter class]], @"valueTransformer is not subclass of NSDateFormatter");
            displayContent = [_dateFormatter stringFromDate:self.rowDescriptor.value];
        } else {
            displayContent = [self.rowDescriptor.value description];
        }
    } else {
        noValue = YES;
        displayContent = self.rowDescriptor.placeHolder;
    }
    
    UIFont *font =
    noValue
    ? ([self formCellPlaceHlderFont])
    : (self.rowDescriptor.disabled ? [self formCellDisabledContentFont] : [self formCellContentFont]);
    UIColor *color =
    noValue
    ? ([self formCellPlaceHolderColor])
    : (self.rowDescriptor.disabled ? [self formCellDisabledContentColor] : [self formCellContentColor]);
    
    return [NSAttributedString rightAttributedStringWithString:displayContent font:font color:color];
}

- (UIView *)jtFormCellInputView
{
    if (![self.rowDescriptor.rowType isEqualToString:JTFormRowTypeDateInline]) {
        if (self.rowDescriptor.value) {
            [self.datePicker setDate:self.rowDescriptor.value animated:[self.rowDescriptor.rowType isEqualToString:JTFormRowTypeCountDownTimer]];
        }
    }
    [self setConfigToDatePicker];
    return self.datePicker;
}

- (void)setConfigToDatePicker
{
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeDate] || [self.rowDescriptor.rowType isEqualToString:JTFormRowTypeDateInline]) {
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeTime]) {
        _datePicker.datePickerMode = UIDatePickerModeTime;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeCountDownTimer]) {
        _datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        _datePicker.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    }
    else {
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    
    if (self.minuteInterval) {
        _datePicker.minuteInterval = self.minuteInterval;
    }
    if (self.minimumDate) {
        _datePicker.minimumDate = self.minimumDate;
    }
    if (self.maximumDate) {
        _datePicker.maximumDate = self.maximumDate;
    }
    if (self.locale) {
        _datePicker.locale = self.locale;
    }
}


#pragma mark - action

- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    self.rowDescriptor.value = sender.date;
    self.contentNode.attributedText = [self cellDisplayContent];
}

#pragma mark - property

- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

#pragma mark - ASEditableTextNodeDelegate

- (BOOL)editableTextNodeShouldBeginEditing:(ASEditableTextNode *)editableTextNode
{
    editableTextNode.textView.inputView = [self jtFormCellInputView];
    return [self.jtForm editableTextShouldBeginEditing:self.rowDescriptor textField:nil editableTextNode:editableTextNode];
}

- (void)editableTextNodeDidBeginEditing:(ASEditableTextNode *)editableTextNode
{
    [self.jtForm editableTextDidBeginEditing:self.rowDescriptor textField:nil editableTextNode:editableTextNode];
}

- (void)editableTextNodeDidFinishEditing:(ASEditableTextNode *)editableTextNode
{
    [self.jtForm editableTextDidEndEditing:self.rowDescriptor textField:nil editableTextNode:editableTextNode];
}
@end
