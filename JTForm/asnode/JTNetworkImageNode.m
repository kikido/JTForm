//
//  JTNetworkImageNode.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTNetworkImageNode.h"
#import <SDWebImage/SDImageCache.h>

@interface JTNetworkImageNode () <ASNetworkImageNodeDelegate>
@property (nonatomic, strong) ASNetworkImageNode *networkImageNode;
@property (nonatomic, strong) ASImageNode *imageNode;
@end

@implementation JTNetworkImageNode

#pragma mark - set

- (void)setImage:(UIImage *)image
{
    _imageNode.image = image;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _networkImageNode.placeholderColor = placeholderColor;
}

- (void)setJtPlaceholderFadeDuratinonatomicon:(NSTimeInterval)jtPlaceholderFadeDuration
{
    _networkImageNode.placeholderFadeDuration = jtPlaceholderFadeDuration;
}

- (void)setDefaultImage:(UIImage *)defaultImage
{
    _networkImageNode.defaultImage = defaultImage;
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

- (void)setImageModificationBlock:(asimagenode_modification_block_t)imageModificationBlock
{
    self.imageNode.imageModificationBlock = imageModificationBlock;
    self.networkImageNode.imageModificationBlock = imageModificationBlock;
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
    [imageCache storeImage:image forKey:imageNode.URL.absoluteString toDisk:YES completion:nil];
}

- (BOOL)hasContent
{
    if (_networkImageNode.URL) {
        return YES;
    }
    if (_imageNode.image) {
        return YES;
    }
    return NO;
}

@end
