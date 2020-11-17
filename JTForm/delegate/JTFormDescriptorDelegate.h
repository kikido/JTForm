//
//  JTFormDescriptorDelegate.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JTRowDescriptor;

@protocol JTFormDescriptorDelegate <NSObject>

/** 在表单中移除了指定索引位置的节 */
- (void)formSectionsHaveBeenRemovedAtIndexes:(NSIndexSet *)indexSet;

/** 在表单中添加了指定索引位置的节 */
- (void)formSectionsHaveBeenAddedAtIndexes:(NSIndexSet *)indexSet;

/** 在表单中添加了指定索引位置的行 */
- (void)formRowHasBeenAddedAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/** 在表单中移除了指定索引位置的行 */
- (void)formRowHasBeenRemovedAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)formRowDescriptorValueHasChanged:(JTRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue;

@end

NS_ASSUME_NONNULL_END
