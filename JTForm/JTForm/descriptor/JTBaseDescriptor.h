//
//  JTBaseDescriptor.h
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JTHelper.h"

#import "JTOptionObject.h"

NS_ASSUME_NONNULL_BEGIN

@class JTFormConfigMode;

@interface JTBaseDescriptor : NSObject

/** Bool值，决定是否隐藏当前的控件(单元行，节，以及整个表单) */
@property (nonatomic, assign) BOOL hidden;

/** Bool值，决定当前控件是否接受响应事件。如果为YES，则不能编辑当前控件内容，仅仅作为展示用 */
@property (nonatomic, assign) BOOL disabled;

/** 配置模型。优先级为row > section > form > 默认 */
@property (nonatomic, strong, nullable) JTFormConfigMode *configMode;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end


/**
 UI配置的模型。可以设置以下内容：
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
@property (nonatomic, strong, nullable) UIColor *bgColor;

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
