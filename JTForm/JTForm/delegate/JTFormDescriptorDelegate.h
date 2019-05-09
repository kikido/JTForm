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
- (void)formSectionsHaveBeenRemovedAtIndexes:(NSIndexSet *)indexSet;

- (void)formSectionsHaveBeenAddedAtIndexes:(NSIndexSet *)indexSet;

- (void)formRowsHaveBeenAddedAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)formRowsHaveBeenRemovedAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
@end

NS_ASSUME_NONNULL_END
