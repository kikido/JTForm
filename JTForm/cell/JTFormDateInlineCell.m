//
//  JTFormDateInlineCell.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTFormDateInlineCell.h"

@interface JTFormDateInlineCell ()
@property (nonatomic, strong, readwrite) UIDatePicker *datePicker;
@property (nonatomic, strong) ASDisplayNode *datePickerNode;
@end

@implementation JTFormDateInlineCell

@synthesize connectedRowDescriptor = _connectedRowDescriptor;

- (void)config
{
    [super config];
    
    __weak typeof(self) weakSelf = self;
    _datePickerNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.backgroundColor = [UIColor whiteColor];
        [datePicker addTarget:strongSelf action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        return datePicker;
    }];
}


- (void)update
{
    [super update];
    _datePicker = (UIDatePicker *)_datePickerNode.view;
    [_datePicker setUserInteractionEnabled:!_connectedRowDescriptor.disabled];
    if (_connectedRowDescriptor.value) {
        [_datePicker setDate:_connectedRowDescriptor.value animated:NO];
    }
}

+ (CGFloat)formCellHeightForRowDescriptor:(JTRowDescriptor *)row
{
    return kJTFormDateInlineDateHeight;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero child:_datePickerNode];
}

#pragma mark - action

- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    if (self.connectedRowDescriptor) {
        self.connectedRowDescriptor.value = sender.date;
        [self.findForm updateFormRow:self.connectedRowDescriptor];
    }
}

@end
