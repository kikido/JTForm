//
//  JTNetworkImageNode.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTNetworkImageNode.h"
#import "JTBaseCell.h"
#import <SDWebImage/SDImageCache.h>
#import <objc/message.h>

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
    _imageNode.placeholderColor        = placeholderColor;
}

- (void)setJtPlaceholderFadeDuratinonatomicon:(NSTimeInterval)jtPlaceholderFadeDuration
{
    _networkImageNode.placeholderFadeDuration = jtPlaceholderFadeDuration;
    _imageNode.placeholderFadeDuration        = jtPlaceholderFadeDuration;
}

- (void)setDefaultImage:(UIImage *)defaultImage
{
    _networkImageNode.defaultImage = defaultImage;
}

- (void)setURL:(NSURL *)URL
{
    if (!URL) return;
    
    NSURL *u = URL;
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:u.absoluteString];
    if (cacheImage) {
        _imageNode.image = cacheImage;
        self.style.preferredSize = CGSizeMake(cacheImage.size.width/([UIScreen mainScreen].scale), cacheImage.size.height/([UIScreen mainScreen].scale));
    } else {
        _networkImageNode.URL = URL;
    }
}

- (void)setImageModificationBlock:(asimagenode_modification_block_t)imageModificationBlock
{
    self.imageNode.imageModificationBlock        = imageModificationBlock;
    self.networkImageNode.imageModificationBlock = imageModificationBlock;
}

- (instancetype)init
{
    if (self = [super init]) {
        _imageNode                         = [[ASImageNode alloc] init];
        _networkImageNode                  = [[ASNetworkImageNode alloc] init];
        _networkImageNode.delegate         = self;
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
    // 不同版本的 sdwebimage 做不同的处理
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    if ([imageCache respondsToSelector:@selector(storeImage:forKey:toDisk:completion:)])
    {
        ((void (*)(id, SEL, UIImage *, NSString *, BOOL, SDWebImageNoParamsBlock))(void *) objc_msgSend)((id)imageCache, @selector(storeImage:forKey:toDisk:completion:), image, imageNode.URL.absoluteString, YES, nil);
    }
    else if ([imageCache respondsToSelector:@selector(storeImage:forKey:toDisk:)])
    {
        ((void (*)(id, SEL, UIImage *, NSString *, BOOL))(void *) objc_msgSend)((id)imageCache, @selector(storeImage:forKey:toDisk:), image, imageNode.URL.absoluteString, YES);
    }
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    /// 因为 ASNetworkImageNode 在 image 下载完之前并不知道具体内容的大小，所以这里等 image 下载完成后，
    /// 根据 scale 给 ASNetworkImageNode 赋值 size，并刷新 cell 的布局
    if ([self.supernode isKindOfClass:[JTBaseCell class]]) {
        self.style.preferredSize = CGSizeMake(image.size.width/scale, image.size.height/scale);
        [self.supernode setNeedsLayout];
        [self.supernode layoutIfNeeded];
    }
}

- (void)imageNode:(ASNetworkImageNode *)imageNode didFailWithError:(NSError *)error
{
    NSLog(@"[JTNetworkImageNode] error: %@", error.localizedDescription);
}

- (BOOL)hasContent
{
    if (_networkImageNode.URL )   return YES;
    if (_imageNode.image)         return YES;
    return NO;
}

@end
