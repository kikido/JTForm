//
//  JTNetworkImageNode.h
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
/**
 * 为了避免表单 reload 时 ASNetworkImageNode 闪烁的问题，自定义的替代类
 */
@interface JTNetworkImageNode : ASDisplayNode

@property (nonatomic, strong) NSURL          *URL;

@property (nonatomic, strong) UIColor        *placeholderColor;

@property (nonatomic, strong) UIImage        *image;

@property (nonatomic, assign) NSTimeInterval jtPlaceholderFadeDuration;

@property (nonatomic, strong) UIImage        *defaultImage;

@property (nullable, nonatomic) asimagenode_modification_block_t imageModificationBlock;

- (BOOL)hasContent;

@end

NS_ASSUME_NONNULL_END
