//
//  JTFormCheckCell.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTFormCheckCell.h"

@interface JTFormCheckCell ()
@property (nonatomic, strong) ASImageNode *accessoryNode;
@end

@implementation JTFormCheckCell

- (void)config
{
    [super config];
    self.accessoryType = UITableViewCellAccessoryNone;
    _accessoryNode = [[ASImageNode alloc] init];
}

- (void)update
{
    [super update];
    
    _accessoryNode.image = [self.rowDescriptor.value boolValue] ? [UIImage imageNamed:@"JTForm.bundle/jt_mark"] : nil;
}

- (void)formCellDidSelected
{
    self.rowDescriptor.value = @(![self.rowDescriptor.value boolValue]);
    _accessoryNode.image = [self.rowDescriptor.value boolValue] ? [UIImage imageNamed:@"JTForm.bundle/jt_mark"] : nil;
}


- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    self.titleNode.style.flexShrink = 1.;
    self.titleNode.style.flexGrow = 1.;
    
    ASStackLayoutSpec *leftStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                           spacing:kJTFormCellImageSpace
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsCenter
                                                                          children:self.imageNode.hasContent ? @[self.imageNode, self.titleNode] : @[self.titleNode]];
    leftStack.style.flexGrow = 1.;
    leftStack.style.flexShrink = 1.;
    
    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                              spacing:15.
                                                                       justifyContent:ASStackLayoutJustifyContentStart
                                                                           alignItems: ASStackLayoutAlignItemsCenter
                                                                             children:@[leftStack, _accessoryNode]];
    contentStack.style.flexGrow = 1.;
    contentStack.style.flexShrink = 1.;
    contentStack.style.minHeight = ASDimensionMake(30.);
    _accessoryNode.style.preferredSize =  CGSizeMake(20.5, 15.);

    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15., 15., 15., 15.) child:contentStack];
}

@end
