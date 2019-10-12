//
//  JTBaseDescriptor.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JTHelper.h"

#import "JTOptionObject.h"

NS_ASSUME_NONNULL_BEGIN

@class JTFormConfigMode;

@interface JTBaseDescriptor : NSObject

/**
 * 当前控件是否隐藏，默认值为 NO
 *
 * @discuss：该属性决定是否隐藏控件，无需手动刷新 UI。在某些情况下，
 * 例如 JTFormRowTypeAlertSelect 样式的单元行弹出 UIAlertController 后设置 hidden 为 YES
 * 隐藏单元行，UIAlertController 并不会消失。
 */
@property (nonatomic, assign) BOOL hidden;

/**
 * 当前控件是否只读，默认为 NO
 *
 * @discuss：如果为 YES，则不能编辑当前控件，只读。在某些情况下，
 * 例如 JTFormRowTypeAlertSelect 样式的单元行弹出 UIAlertController 后设置 hidden 为 YES
 * 隐藏单元行，UIAlertController 并不会消失。
 */
@property (nonatomic, assign) BOOL disabled;

/**
 * 控件 UI 配置模型
 *
 * 优先级 row > section > form > 默认值，默认值可在 JTFormCellLayout.h 文件中修改
 */
@property (nonatomic, strong, nullable) JTFormConfigMode *configMode;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

/**
 UI配置的模型。
 
 可以设置以下内容：
 - 背景颜色
 - 占位符颜色和字体

 <1> 可编辑状态时
 1. 标题颜色和字体
 2. 详情颜色和字体
 
 <2> 禁用状态时
 1. 标题颜色和字体
 2. 详情颜色和字体
 */
@interface JTFormConfigMode : NSObject
/** 标题颜色 */
@property (nonatomic, strong, nullable) UIColor *titleColor;
/** 内容颜色 */
@property (nonatomic, strong, nullable) UIColor *contentColor;
/** 占位符颜色 */
@property (nonatomic, strong, nullable) UIColor *placeHolderColor;
/** 禁用时标题颜色 */
@property (nonatomic, strong, nullable) UIColor *disabledTitleColor;
/** 禁用时内容颜色 */
@property (nonatomic, strong, nullable) UIColor *disabledContentColor;
/** 控件背景颜色 */
@property (nonatomic, strong, nullable) UIColor *backgroundColor;

/** 标题字体 */
@property (nonatomic, strong, nullable) UIFont *titleFont;
/** 内容字体 */
@property (nonatomic, strong, nullable) UIFont *contentFont;
/** 占位符字体 */
@property (nonatomic, strong, nullable) UIFont *placeHlderFont;
/** 禁用时标题字体 */
@property (nonatomic, strong, nullable) UIFont *disabledTitleFont;
/** 禁用时内容字体 */
@property (nonatomic, strong, nullable) UIFont *disabledContentFont;

@end

NS_ASSUME_NONNULL_END
