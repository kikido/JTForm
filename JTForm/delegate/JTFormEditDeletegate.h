//
//  JTFormEditDeletegate.h
//
//  JTFormEditDeletegate.h
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

/** 对form做了添加或者删除 */
@protocol JTFormEditDeletegate <NSObject>

@optional

- (void)jtForm:(JTForm *)jtForm commitEditingStyle:(JTFormCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
