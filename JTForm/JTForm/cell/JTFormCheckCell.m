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
    _accessoryNode.image = [UIImage imageNamed:@"jt_cell_disclosureIndicator.png"];
}

- (void)update
{
    [super update];
    
    BOOL required = self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle;
    self.titleNode.attributedText = [NSAttributedString
                                     attributedStringWithString:[NSString stringWithFormat:@"%@%@",required ? @"*" : @"", self.rowDescriptor.title]
                                     font:self.rowDescriptor.disabled ? [self formCellDisabledTitleFont] : [self formCellTitleFont]
                                     color:self.rowDescriptor.disabled ? [self formCellDisabledTitleColor] : [self formCellTitleColor]
                                     firstWordColor:required ? kJTFormRequiredCellFirstWordColor : nil];
    _accessoryNode.image = [self.rowDescriptor.value boolValue] ? [UIImage imageNamed:@"jt_cell_disclosureIndicator.png"] : nil;
}

- (void)formCellDidSelected
{
    self.rowDescriptor.value = @(![self.rowDescriptor.value boolValue]);
    _accessoryNode.image = [self.rowDescriptor.value boolValue] ? [UIImage imageNamed:@"jt_cell_disclosureIndicator.png"] : nil;
}


- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    self.titleNode.style.flexShrink = 1.;
    self.titleNode.style.flexGrow = 1.;
    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                              spacing:30.
                                                                       justifyContent:ASStackLayoutJustifyContentStart
                                                                           alignItems: ASStackLayoutAlignItemsCenter
                                                                             children:@[self.titleNode, _accessoryNode]];
    contentStack.style.flexGrow = 1.;
    contentStack.style.flexShrink = 1.;
    contentStack.style.minHeight = ASDimensionMake(30.);
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15., 15., 15., 15.) child:contentStack];
}

@end
