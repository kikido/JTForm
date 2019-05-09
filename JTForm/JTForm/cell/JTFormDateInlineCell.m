//
//  JTFormDateInlineCell.m
//  JTForm
//
//  Created by dqh on 2019/4/25.
//  Copyright © 2019 dqh. All rights reserved.
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
        [datePicker addTarget:strongSelf action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        strongSelf.datePicker = datePicker;
        return datePicker;
    }];
}


- (void)update
{
    [super update];
    [self.datePickerNode setUserInteractionEnabled:!self.rowDescriptor.disabled];
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
