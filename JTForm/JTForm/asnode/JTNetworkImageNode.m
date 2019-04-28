//
//  JTNetworkImageNode.m
//  JTForm
//
//  Created by dqh on 2019/4/15.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTNetworkImageNode.h"
#import <SDImageCache.h>

@interface JTNetworkImageNode () <ASNetworkImageNodeDelegate>
@property (nonatomic, strong) ASNetworkImageNode *networkImageNode;
@property (nonatomic, strong) ASImageNode *imageNode;
@end

@implementation JTNetworkImageNode

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _networkImageNode.placeholderColor = placeholderColor;
}


- (void)setImage:(UIImage *)image
{
    _networkImageNode.image = image;
}

- (void)setPlaceholderFadeDuration:(NSTimeInterval)placeholderFadeDuration
{
    _networkImageNode.placeholderFadeDuration = placeholderFadeDuration;
}

- (void)setURL:(NSURL *)URL
{
    NSURL *u = URL;
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:u.absoluteString];
    if (cacheImage) {
        _imageNode.image = cacheImage;
    } else {
        _networkImageNode.URL = URL;
    }
}

- (instancetype)init
{
    if (self = [super init]) {
        _imageNode = [[ASImageNode alloc] init];
        _networkImageNode = [[ASNetworkImageNode alloc] init];
        _networkImageNode.delegate = self;
        _networkImageNode.shouldCacheImage = false;
        [self addSubnode:_imageNode];
        [self addSubnode:_networkImageNode];
    }
    return self;
}
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero child:_networkImageNode.URL ? _networkImageNode : _imageNode];
}


- (void)addTarget:(id)target action:(SEL)action forControlEvents:(ASControlNodeEvent)controlEvents
{
    [_networkImageNode addTarget:target action:action forControlEvents:controlEvents];
    [_imageNode addTarget:target action:action forControlEvents:controlEvents];
}

#pragma mark - ASNetworkImageNodeDelegate

- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image
{
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache storeImage:image forKey:imageNode.URL.absoluteString toDisk:YES];
}


@end