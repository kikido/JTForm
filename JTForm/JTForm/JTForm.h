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

@interface JTForm : UIView
- (instancetype)initWithFormDescriptor:(JTFormDescriptor *)formDescriptor NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END
