//
//  JTBaseCellDelegate.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JTRowDescriptor;

@protocol JTBaseCellDelegate <NSObject>

@optional

/** 指定单元行的高度 */
+ (CGFloat)formCellHeightForRowDescriptor:(JTRowDescriptor *)row;

/**  当前的单元行被选中了 */
- (void)formCellDidSelected;

/**
 为该cell设置一个HttpParameterName，那么当调用JTFormDescriptor的实例方法-(void)httpParameters时，则会将该行，以方法返回值为key，值为value添加到结果字典中
 为单元行设置一个参数名称key，用于网络请求。设置成功之后，调用‘JTFormDescriptor’的实例方法‘httpParameters’，会返回一个@{key : self.rowDescriptor.value}的字典。如果不指定名称key，则key为tag值。
 */
- (NSString *)formDescriptorHttpParameterName;
@end

NS_ASSUME_NONNULL_END
