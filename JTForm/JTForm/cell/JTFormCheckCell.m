//
//  JTFormCheckCell.m
//  JTForm
//
//  Created by dqh on 2019/5/5.
//  Copyright © 2019 dqh. All rights reserved.
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
    
    self.imageNode.image = self.rowDescriptor.image;
    self.imageNode.URL = self.rowDescriptor.imageUrl;
    
    BOOL required = self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle;
    self.titleNode.attributedText = [NSAttributedString
                                     attributedStringWithString:[NSString stringWithFormat:@"%@%@",required ? @"*" : @"", self.rowDescriptor.title]
                                     font:self.rowDescriptor.disabled ? [self formCellDisabledTitleFont] : [self formCellTitleFont]
                                     color:self.rowDescriptor.disabled ? [self formCellDisabledTitleColor] : [self formCellTitleColor]
                                     firstWordColor:required ? kJTFormRequiredCellFirstWordColor : nil];
    _accessoryNode.image = [self.rowDescriptor.value boolValue] ? [UIImage imageNamed:@"jt_mark"] : nil;
}

- (void)formCellDidSelected
{
    self.rowDescriptor.value = @(![self.rowDescriptor.value boolValue]);
    _accessoryNode.image = [self.rowDescriptor.value boolValue] ? [UIImage imageNamed:@"jt_mark"] : nil;
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
