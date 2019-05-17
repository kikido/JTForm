//
//  JTFromSwitchCell.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//
#import "JTFromSwitchCell.h"

@interface JTFromSwitchCell ()
@property (nonatomic, strong) ASDisplayNode *accessoryNode;
@end

@implementation JTFromSwitchCell

- (void)config
{
    [super config];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _accessoryNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        UISwitch *switchControl = [[UISwitch alloc] init];
        switchControl.backgroundColor = [UIColor clearColor];
        [switchControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        return switchControl;
    }];
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
    
    UISwitch *switchControl = (UISwitch *)self.accessoryNode.view;
    switchControl.on = [self.rowDescriptor.value boolValue];
    switchControl.enabled = !self.rowDescriptor.disabled;
    self.switchControl = switchControl;
}

- (void)valueChanged:(UISwitch *)sender
{
    self.rowDescriptor.value = @(sender.on);
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    self.accessoryNode.style.preferredSize = CGSizeMake(51., 31.);
    self.titleNode.style.flexShrink = 1.;
    
    ASStackLayoutSpec *leftStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                           spacing:kJTFormCellImageSpace
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsCenter
                                                                          children:self.imageNode.hasContent ? @[self.imageNode, self.titleNode] : @[self.titleNode]];
    leftStack.style.flexGrow = 1.;
    leftStack.style.flexShrink = 1.;
    
    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                              spacing:15.
                                                                       justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                           alignItems: ASStackLayoutAlignItemsCenter
                                                                             children:@[leftStack, self.accessoryNode]];
    contentStack.style.flexGrow = 1.;
    contentStack.style.flexShrink = 1.;
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15., 15., 15., 15.) child:contentStack];
}

@end
