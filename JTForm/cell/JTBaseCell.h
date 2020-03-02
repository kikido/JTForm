//
//  JTBaseCell.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTNetworkImageNode.h"
#import "JTForm.h"

@class JTRowDescriptor;
@class JTSectionDescriptor;

NS_ASSUME_NONNULL_BEGIN

/**
 * JTForm 的 cell，
 *
 * @note 如果你需要自定义单元行，请继承于该类
 * @discuss 继承自 Texture 的 ASCellNode，达到流畅目的。当 cell 被添加到 JTForm 中时，如果需要重新更新 cell frame 大小，
 * 你可以手动调用 ‘- setNeedsLayout’ 方法
 */
@interface JTBaseCell : ASCellNode <JTBaseCellDelegate>
/** 数据源：行描述 */
@property (nonatomic, weak) JTRowDescriptor *rowDescriptor;

/**
 * title label
 *
 * 在 JTFrorm 中的单元行处于左边位置
 */
@property (nonatomic, strong) ASTextNode *titleNode;

/**
 * content label
 *
 * 在 JTForm 中的单元行处于右边位置
 */
@property (nonatomic, strong) ASTextNode *contentNode;

/**
 * title image
 *
 * 在 JTForm 中的单元行处于 titleNode 前面的位置
 */
@property (nonatomic, strong) JTNetworkImageNode *imageNode;

/**
 * 初始化控件
 *
 * 不需要为控件设置 frame，不需要为控件设置内容。
 * 创建后只会调用一次该方法，除非使用方法 ‘-reloadCellWithNewRowType’
 *
 *  @note 在这个方法里面不要对 node 的 view 或者 layer 的属性进行设置，因为该方法不在主线程中被调用，如果设置这些属性会报错
 */
- (void)config NS_REQUIRES_SUPER;

/**
 * 更新控件内容
 *
 * 可能会被多次调用
 */
- (void)update NS_REQUIRES_SUPER;

/**
 * 查找被添加的表单
 *
 * @return 表单
 */
- (JTForm *)findForm;

/**
 * 查找被添加的表单的表描述
 *
 * @return 表描述
 */
- (JTFormDescriptor *)findFormDescriptor;

//------------------------------
/// @name responder
///-----------------------------

- (BOOL)cellCanBecomeFirstResponder;

- (BOOL)cellBecomeFirstResponder;

//------------------------------
/// @name UI
///-----------------------------

- (UIColor *)cellTitleColor;

- (UIColor *)cellContentColor;

/**
 * 只读时详情的字体颜色
 *
 * @note 在 JTForm 中，该方法仅用在 JTFormRowTypeInfo 样式的单元行中，
 * 因为这个样式的单元行内容本身就是只读的，不受 disabled 属性的影响。
 * 通常情况下请使用 ‘-cellContentColor’方法获取字体颜色
 *
 * @return 颜色
 */
- (UIColor *)cellDisabledContentColor;

- (UIColor *)cellPlaceHolerColor;

- (UIFont *)cellTitleFont;

- (UIFont *)cellContentFont;

- (UIFont *)cellPlaceHolerFont;

- (UIFont *)cellDisabledContentFont;

- (UIColor *)cellBackgroundColor;

- (void)cellHighLight NS_REQUIRES_SUPER;

- (void)cellUnHighLight NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
