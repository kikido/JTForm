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

/** 移除了某些位置的节描述 */
- (void)formSectionsHaveBeenRemovedAtIndexes:(NSIndexSet *)indexSet;

/** 在某些位置添加了节描述 */
- (void)formSectionsHaveBeenAddedAtIndexes:(NSIndexSet *)indexSet;

/** 在某些位置添加了行描述 */
- (void)formRowsHaveBeenAddedAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/** 移除了某些位置的行描述 */
- (void)formRowsHaveBeenRemovedAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)formRowDescriptorValueHasChanged:(JTRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue;

@end

NS_ASSUME_NONNULL_END
