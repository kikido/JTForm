//
//  JTFormCellLayout.h
//  JTForm
//
//  Created by dqh on 2019/4/19.
//  Copyright © 2019 dqh. All rights reserved.
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
/** 屏幕高度 */
#define kJTScreenHeight ([UIScreen mainScreen].bounds.size.height)
/** 屏幕宽度 */
#define kJTScreenWidth ([UIScreen mainScreen].bounds.size.width)
/** 缩放比 */
#define kJTScreenScale ([UIScreen mainScreen].scale)
/** 单元行标题跟图片之前的间隔 */
#define kJTFormCellImageSpace 10.


#endif /* JTFormCellLayout_h */
