//
//  ASDisplayNode+JTFormAdditions.h
//  JTForm
//
//  Created by dqh on 2019/4/15.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JTBaseCell;

@interface ASDisplayNode (JTFormAdditions)

- (ASDisplayNode *)findFirstResponder;

- (JTBaseCell *)formCell;

@end

NS_ASSUME_NONNULL_END
