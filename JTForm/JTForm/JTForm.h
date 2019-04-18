//
//  JTForm.h
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "JTFormDescriptor.h"

NS_ASSUME_NONNULL_BEGIN

@class JTFormDescriptor;
@class JTRowDescriptor;

@interface JTForm : UIView <ASEditableTextNodeDelegate>

@property (nonatomic, strong) ASTableNode *tableNode;

- (instancetype)initWithFormDescriptor:(JTFormDescriptor *)formDescriptor;

+ (NSMutableDictionary *)cellClassesForRowDescriptorTypes;

+ (NSMutableDictionary *)inlineRowDescriptorTypesForRowDescriptorTypes;

#pragma mark -

#pragma mark - edit text

- (void)beginEditing:(JTRowDescriptor *)row;

- (void)endEditing:(JTRowDescriptor *)row;

@end

NS_ASSUME_NONNULL_END
