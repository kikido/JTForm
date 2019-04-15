//
//  JTForm.h
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "JTFormDescriptor.h"

#import "JTDefaultCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTForm : UIView

@property (nonatomic, strong) ASTableNode *tableNode;


- (instancetype)initWithFormDescriptor:(JTFormDescriptor *)formDescriptor NS_DESIGNATED_INITIALIZER;

+ (NSMutableDictionary *)cellClassesForRowDescriptorTypes;
@end

NS_ASSUME_NONNULL_END
