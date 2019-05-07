//
//  JTNetworkImageNode.h
//  JTForm
//
//  Created by dqh on 2019/4/15.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 为了避免reload时'ASNetworkImageNode'闪烁的问题，所自定义的替代类
 */
@interface JTNetworkImageNode : ASDisplayNode

@property (nonatomic, copy  ) NSURL          *URL;

@property (nonatomic, strong) UIColor        *placeholderColor;

@property (nonatomic, strong) UIImage        *image;

@property (nonatomic, assign) NSTimeInterval jtPlaceholderFadeDuration;

@property (nonatomic, strong) UIImage        *defaultImage;

- (BOOL)hasContent;

@end

NS_ASSUME_NONNULL_END
