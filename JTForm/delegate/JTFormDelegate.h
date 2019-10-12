//
//  JTFormDelegate.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSUInteger, JTFormCellEditingStyle) {
    JTFormCellEditingStyleDelete = 0
};

@class JTForm;
@class JTRowDescriptor;

@protocol JTFormDelegate <NSObject>

@optional

/**
 * 单元行 value 已改变
 *
 * @param jtForm 表单 form
 * @param row 行描述
 * @param oldValue 旧值，可能为空
 * @param newValue 新值，不能为空
 */
- (void)form:(JTForm *)jtForm rowValueHasChanged:(JTRowDescriptor *)row oldValue:(nullable id)oldValue newValue:(id)newValue;

/**
 * 单元行经过编辑(目前仅支持删除)
 *
 * @param jtForm 表单 form
 * @param editingStyle 编辑样式
 * @param indexPath 单元行的索引位置
 */
- (void)form:(JTForm *)jtForm commitEditingStyle:(JTFormCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;


/** 完成数据加载之后必须使用‘[context completeBatchFetching:YES]’ */

/**
 * tail 加载(上拉加载更多)
 *
 * @note：加载出来数据并做相应处理后，需要调用方法'[context completeBatchFetching:YES]'
 * 来通知上下文批量操作已结束
 *
 * @param context 上下文，用来通知批量操作结束或者取消
 */
- (void)tailLoadWithContent:(ASBatchContext *)context;

@end

NS_ASSUME_NONNULL_END
