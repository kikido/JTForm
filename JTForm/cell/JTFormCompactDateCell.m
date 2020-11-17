//
//  JTFormCompactDateCell.m
//  JTFormDemo
//
//  Created by dqh on 2020/9/24.
//  Copyright © 2020 dqh. All rights reserved.
//

#import "JTFormCompactDateCell.h"

@interface JTFormCompactDateCell () <ASEditableTextNodeDelegate>
@property (nonatomic, strong, readonly) UIDatePicker *datePicker;
@property (nonatomic, strong) ASDisplayNode *datePickerNode;
@end

@implementation JTFormCompactDateCell

- (void)config
{
    [super config];

    _datePickerNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        if (@available(iOS 14.0, *)) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyleCompact;
        }
        [datePicker addTarget:self action:@selector(datePickerValueChanged:)    forControlEvents:UIControlEventValueChanged];
        [datePicker addTarget:self action:@selector(datePickerEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [datePicker addTarget:self action:@selector(datePickerEditingDidEnd:)   forControlEvents:UIControlEventEditingDidEnd];
        return datePicker;
    }];
}

- (void)update
{
    [super update];
    
    UIDatePicker *datePicker = (UIDatePicker *)self.datePickerNode.view;
    datePicker.enabled = !self.rowDescriptor.disabled;
    _datePicker = datePicker;
    [self setConfigToDatePicker];
    
    if (self.rowDescriptor.value) {
        [datePicker setDate:self.rowDescriptor.value animated:NO];
    } else {
        self.rowDescriptor.value = datePicker.date;
    }
    [datePicker sizeToFit];
    self.datePickerNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(datePicker.frame.size.width), ASDimensionMake(datePicker.frame.size.height));
}

#pragma mark - responder

- (BOOL)canBecomeFirstResponder
{
    return false;
}

- (BOOL)becomeFirstResponder
{
    return false;
}

- (BOOL)isFirstResponder
{
    return self.datePicker.selected;
}

- (BOOL)canResignFirstResponder
{
    return [super canResignFirstResponder];
}

- (BOOL)resignFirstResponder
{
    if ([self canResignFirstResponder]) {
        // FIXME: 无法找到更好的办法来关闭日期弹框
        if ([self isFirstResponder] && self.closestViewController.presentedViewController != nil) {
            self.datePicker.selected = false;
            [self.closestViewController dismissViewControllerAnimated:true completion:nil];
        }
    }
    return false;
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
        
    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                              spacing:15.
                                                                       justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                           alignItems: ASStackLayoutAlignItemsCenter
                                                                             children:@[leftStack, self.datePickerNode]];
    contentStack.style.minHeight = ASDimensionMake(30.);
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(12., 15., 12., 15.) child:contentStack];
}

#pragma mark - helper

- (void)setConfigToDatePicker
{
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeDate]) {
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeTime]) {
        _datePicker.datePickerMode = UIDatePickerModeTime;
    }
    else {
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    if (self.minuteInterval) _datePicker.minuteInterval = [self.minuteInterval integerValue];
    if (self.minimumDate)    _datePicker.minimumDate    = self.minimumDate;
    if (self.maximumDate)    _datePicker.maximumDate    = self.maximumDate;
    if (self.locale)         _datePicker.locale         = self.locale;
}

#pragma mark - action

- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    [self.rowDescriptor manualSetValue:sender.date];
}

- (void)datePickerEditingDidBegin:(UIDatePicker *)sender
{
    sender.selected = true;
    [self.findForm beginEditing:self.rowDescriptor];
}

- (void)datePickerEditingDidEnd:(UIDatePicker *)sender
{
    sender.selected = false;
    [self.findForm endEditing:self.rowDescriptor];

    [sender sizeToFit];
    self.datePickerNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(sender.frame.size.width), ASDimensionMake(sender.frame.size.height));
    [self setNeedsLayout];
}

@end
