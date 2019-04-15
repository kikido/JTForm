//
//  JTDefaultCell.m
//  JTForm
//
//  Created by dqh on 2019/4/15.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTDefaultCell.h"

NSString *const JTFormRowTypeDefault = @"JTFormRowTypeDefault";

@interface JTDefaultCell ()
@property (nonatomic, strong) ASImageNode *imageNode;
@property (nonatomic, strong) ASTextNode *textNode;
@property (nonatomic, strong) ASTextNode *detailTextNode;
@end

@implementation JTDefaultCell

- (void)config
{
    _imageNode = [[ASImageNode alloc] init];
    _imageNode.layerBacked = YES;
    
    _textNode = [[ASTextNode alloc] init];
    _textNode.style.flexShrink = 1.0;
    _textNode.layerBacked = YES;
    
    _detailTextNode = [[ASTextNode alloc] init];
    _detailTextNode.style.flexShrink = 2.0;
    _detailTextNode.layerBacked = YES;
    
    self.automaticallyManagesSubnodes = YES;
}

- (void)update
{
    _imageNode.image = [UIImage imageNamed:@"icon_first_che1"];
    
    _textNode.attributedText = [NSAttributedString attributedStringWithString:self.rowDescriptor.title fontSize:15. color:nil firstWordColor:[UIColor jt_colorWithHexString:@"ff3131"]];
    
    _detailTextNode.attributedText = [NSAttributedString attributedStringWithString:self.rowDescriptor.value fontSize:15. color:nil firstWordColor:[UIColor jt_colorWithHexString:@"ff3131"]];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                              spacing:15.
                                                                       justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStretch
                                                                             children:@[_imageNode, _textNode, _detailTextNode]];
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15., 15., 15., 15.) child:contentStack];
}

@end
