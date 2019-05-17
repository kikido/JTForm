//
//  ASDisplayNode+JTFormAdditions.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#if __has_include (<AsyncDisplayKit/AsyncDisplayKit.h>)
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class ASDisplayNode;

@class JTBaseCell;

@interface ASDisplayNode (JTAdd)

- (ASDisplayNode *)findFirstResponder;

@end

NS_ASSUME_NONNULL_END
