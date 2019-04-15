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

/**
 图片的网络地址
 */
@property (nonatomic, copy) NSURL *URL;

/**
 转场color
 */
@property (nonatomic, strong)UIColor *placeholderColor;

/**
 静态image
 */
@property (nonatomic, strong)UIImage *image;

/**
 转场时间
 */
@property (nonatomic, assign)NSTimeInterval jt_placeholderFadeDuration;

/**
 空置图片
 */
@property (nonatomic, strong)UIImage *defaultImage;

@end

NS_ASSUME_NONNULL_END
