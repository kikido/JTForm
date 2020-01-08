//
//  ImageCell.m
//  JTFormDemo
//
//  Created by dqh on 2019/12/19.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "ImageCell.h"

NSString * const JTFormRowTypeCollectionImageCell = @"JTFormRowTypeCollectionImageCell";

@implementation ImageCell {
    ASNetworkImageNode *_imageNode;
}

+ (void)load
{
    [[JTForm cellClassesForRowTypes] setObject:[ImageCell class] forKey:JTFormRowTypeCollectionImageCell];
}

- (void)config
{
    [super config];
    _imageNode = [[ASImageNode alloc] init];
}

- (void)update
{
    [super update];
    self.backgroundColor = UIColor.blackColor;
    _imageNode.image = self.rowDescriptor.image;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    CGSize imageSize = self.rowDescriptor.image.size;
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero
                                                  child:[ASRatioLayoutSpec ratioLayoutSpecWithRatio:imageSize.height/imageSize.width
                                                                                              child:_imageNode]];
}
@end
