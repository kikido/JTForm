//
//  JTFormDescriptorDelegate.h
//  JTForm
//
//  Created by dqh on 2019/5/9.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JTFormDescriptorDelegate <NSObject>

/** 移除了某些位置的节描述 */
- (void)formSectionsHaveBeenRemovedAtIndexes:(NSIndexSet *)indexSet;

/** 在某些位置添加了节描述 */
- (void)formSectionsHaveBeenAddedAtIndexes:(NSIndexSet *)indexSet;

/** 在某些位置添加了行描述 */
- (void)formRowsHaveBeenAddedAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/** 移除了某些位置的行描述 */
- (void)formRowsHaveBeenRemovedAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

@end

NS_ASSUME_NONNULL_END
