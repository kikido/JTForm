//
//  JTFormCellLayout.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#ifndef JTFormCellLayout_h
#define JTFormCellLayout_h

/** textfield类单元行标题的最大高度 */
#define kJTFormTextFieldCellMaxTitlteHeight 100.

/** textview类单元行标题的最大宽度占整行的比例 */
#define kJTFormTextViewCellMaxTitleWidthFraction 0.3

/** textview类型单元行textview的最小高度 */
#define kJTFormMinTextViewHeight 100.

//|-----------------------------------------------------------------||//
#pragma mark - select

#define kJTFormSelectMaxContentHeight 50.

#define kJTFormSelectMaxTitleHeight 75.

//|-----------------------------------------------------------------||//
#pragma mark - date

#define kJTFormDateMaxContentHeight 50.

#define kJTFormDateMaxTitleHeight 75.

/** ‘date’类单元行内容宽度的最大占比 */
#define kJTFormDateMaxContentWidthFraction 0.5

/** 内联日期选择器的高度 */
#define kJTFormDateInlineDateHeight 216.0

//|-----------------------------------------------------------------||//
#pragma mark - other

/** 'SegmentedControl'cell每一个item的宽度 */
#define kJTFormSegmentedControlItemWidth 50.

#define kJTFormSliderMinHeight 30.

//|-----------------------------------------------------------------||//
#pragma mark - custom

#define kJTFormFloatTextCellTitltFont [UIFont preferredFontForTextStyle:UIFontTextStyleBody]

/** 必填项‘*’号的颜色 */
#define kJTFormRequiredCellFirstWordColor UIColorHex(ff3131)
/**
 * 单元行高亮时 title 的颜色
 *
 * 本来想用 tintcolor，但是在某种情况下发现系统的 tintcolor 会改变（从 blue 到 gray），
 * 所以还是自己自定义一个颜色吧
 */
#define kJTFormHighLightColor ([UIColor blueColor])
/** 屏幕高度 */
#define kJTScreenHeight ([UIScreen mainScreen].bounds.size.height)
/** 屏幕宽度 */
#define kJTScreenWidth ([UIScreen mainScreen].bounds.size.width)
/** 缩放比 */
#define kJTScreenScale ([UIScreen mainScreen].scale)
/** 单元行标题跟图片之前的间隔 */
#define kJTFormCellImageSpace 10.


#endif /* JTFormCellLayout_h */
