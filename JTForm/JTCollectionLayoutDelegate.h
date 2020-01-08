//
//  JTCollectionLayoutDelegate.h
//  JTFormDemo
//
//  Created by dqh on 2019/12/18.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "JTCollectionLayoutInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTCollectionLayoutDelegate : NSObject <ASCollectionLayoutDelegate>

- (instancetype)initWithInfo:(JTCollectionLayoutInfo *)info;

- (instancetype)init __unavailable;
- (instancetype)new __unavailable;
@end

NS_ASSUME_NONNULL_END
