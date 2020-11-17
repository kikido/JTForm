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

//------------------------------
/// @name text cell
///-----------------------------

/** textfield类单元行标题的最大高度 */
#define kJTFormTextFieldCellMaxTitlteHeight 100.
/** textview类单元行标题的最大宽度占整行的比例 */
#define kJTFormTextViewCellMaxTitleWidthFraction 0.3
/** textview类型单元行textview的最小高度 */
#define kJTFormMinTextViewHeight 100.

//------------------------------
/// @name select cell
///-----------------------------

#define kJTFormSelectMaxContentHeight 50.
#define kJTFormSelectMaxTitleHeight 75.

//------------------------------
/// @name date cell
///-----------------------------

#define kJTFormDateMaxContentHeight 50.
#define kJTFormDateMaxTitleHeight 75.
/** ‘date’类单元行内容宽度的最大占比 */
#define kJTFormDateMaxContentWidthFraction 0.5
/** 内联日期选择器的高度 */
#define kJTFormDateInlineDateHeight 216.0

//------------------------------
/// @name other
///-----------------------------

/** 'SegmentedControl'cell每一个item的宽度 */
#define kJTFormSegmentedControlItemWidth 50.
#define kJTFormSliderMinHeight 30.
/** 单元行标题跟图片之前的间隔 */
#define kJTFormCellImageSpace 10.
/** 屏幕高度 */
#define kJTScreenHeight ([UIScreen mainScreen].bounds.size.height)
/** 屏幕宽度 */
#define kJTScreenWidth ([UIScreen mainScreen].bounds.size.width)
/** 缩放比 */
#define kJTScreenScale ([UIScreen mainScreen].scale)

#pragma mark - row config
//------------------------------
/// @name Color
///-----------------------------

/** default background color */
#define kJTFormCellDefaultBackgroundColor [UIColor whiteColor]
/** default title color */
#define kJTFormCellDefaultTitleColor UIColorHex(333333)
/** default content color */
#define kJTFormCellDefaultContentColor UIColorHex(333333)
/** default content placeholder color */
#define kJTFormCellDefaultPlaceHolderColor UIColorHex(dbdbdb)
/** disabled title color */
#define kJTFormCellDisabledTitleColor UIColorHex(aaaaaa)
/** disabled content color */
#define kJTFormCellDisabledContentColor UIColorHex(d7d7d7)
/** 单元行高亮时 title 的颜色 */
#define kJTFormCellHighLightColor UIColorHex(407eea)

/** 必填项‘*’号的颜色 */
#define kJTFormRequiredCellFirstWordColor UIColorHex(ff3131)


//------------------------------
/// @name Font
///-----------------------------

/** default title font */
#define kJTFormCellDefaultTitleFont [UIFont systemFontOfSize:16.]
/** default content font */
#define kJTFormCellDefaultContentFont [UIFont systemFontOfSize:15.]
/** default placeholder font */
#define kJTFormCellDefaultPlaceHolderFont [UIFont systemFontOfSize:15.]
/** disabled title font */
#define kJTFormCellDisabledTitleFont [UIFont systemFontOfSize:16.]
/** disabled content font */
#define kJTFormCellDisabledContentFont [UIFont systemFontOfSize:15.]

/** float style title font */
#define kJTFormFloatTextCellTitltFont [UIFont boldSystemFontOfSize:12.0f]

#endif /* JTFormCellLayout_h */
