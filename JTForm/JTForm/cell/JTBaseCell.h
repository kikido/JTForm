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

@protocol JTBaseCellDelegate <NSObject>

@required

/**
 初始化。在这个方法里只需要添加好需要显示的控件，但不需要为控件添加要显示的内容。在生命周期内只会被调用一次
 */
- (void)config;


/**
 更新视图内容，可以被多次调用
 */
- (void)update;


@optional

/**
 指定单元行的高度，如果不实现这个方法，则为自动布局
 
 */
+ (CGFloat)formCellHeightForRowDescriptor:(JTRowDescriptor *)row;


/**
 返回一个bool值，指示单元行是否能够成为第一响应者,默认返回NO
 
 */
- (BOOL)formCellCanBecomeFirstResponder;


/**
 让当前的单元行成为第一响应者
 
 */
- (BOOL)formCellBecomeFirstResponder;


/**
 当前的单元行被选中了
 
 */
- (void)formCellDidSelected;


/**
 为该cell设置一个HttpParameterName，那么当调用JYFormDescriptor的实例方法-(void)httpParameters时，则会将该行，以方法返回值为key，值为value添加到结果字典中
 为单元行设置一个参数名称key，用于网络请求。设置成功之后，调用‘JTFormDescriptor’的实例方法‘httpParameters’，会返回一个@{key : self.rowDescriptor.value}的字典。如果不指定名称key，则key为tag值。
 
 */
- (NSString *)formDescriptorHttpParameterName;


/**
 当单元行成为第一响应者时被调用，可以通过该方法改变cell的样式
 
 */
- (void)formCellHighlight;


/**
 当单元行退出第一响应者时被调用
 
 */
- (void)formCellUnhighlight;

@end


@interface JTBaseCell : ASCellNode <JTBaseCellDelegate>

@property (nonatomic, weak) JTRowDescriptor *rowDescriptor;

@end

NS_ASSUME_NONNULL_END
