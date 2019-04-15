//
//  JTBaseCell.h
//  JTForm
//
//  Created by dqh on 2019/4/10.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "JTNetworkImageNode.h"
#import "JTRowDescriptor.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTBaseCell : ASCellNode

@property (nonatomic, weak) JTRowDescriptor *rowDescriptor;


/**
 初始化。在这个方法里只需要添加好需要显示的控件，但不需要为控件添加要显示的内容。在生命周期内只会被调用一次
 */
- (void)config;


/**
 更新视图内容，可以被多次调用
 */
- (void)update;

@end

NS_ASSUME_NONNULL_END
