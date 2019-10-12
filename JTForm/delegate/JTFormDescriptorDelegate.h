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

/** 在表单中移除了指定索引位置的节描述 */
- (void)formSectionsHaveBeenRemovedAtIndexes:(NSIndexSet *)indexSet;

/** 在表单中添加了指定索引位置的节描述 */
- (void)formSectionsHaveBeenAddedAtIndexes:(NSIndexSet *)indexSet;

/** 在表单中添加了指定索引位置的行描述 */
- (void)formRowHasBeenAddedAtIndexPath:(NSIndexPath *)indexPath;

/** 在表单中移除了指定索引位置的行描述 */
- (void)formRowHasBeenRemovedAtIndexPath:(NSIndexPath *)indexPath;

- (void)formRowDescriptorValueHasChanged:(JTRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue;

@end

NS_ASSUME_NONNULL_END
