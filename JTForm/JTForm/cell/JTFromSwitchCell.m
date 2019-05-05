//
//  JTFromSwitchCell.m
//  JTForm
//
//  Created by dqh on 2019/5/5.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTFromSwitchCell.h"

@interface JTFromSwitchCell ()
@property (nonatomic, strong) ASDisplayNode *accessoryNode;
@property (nonatomic, strong) UISwitch *switchControl;
@end

@implementation JTFromSwitchCell

- (void)config
{
    [super config];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _accessoryNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        self.switchControl = [[UISwitch alloc] init];
        self.switchControl.backgroundColor = [UIColor yellowColor];
        [self.switchControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        return self.switchControl;
    }];
    _accessoryNode.backgroundColor = [UIColor redColor];
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
    self.switchControl.on = [self.rowDescriptor.value boolValue];
    self.switchControl.enabled = !self.rowDescriptor.disabled;
}

- (void)valueChanged:(UISwitch *)sender
{
    self.rowDescriptor.value = @(sender.on);
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    self.accessoryNode.style.preferredSize = CGSizeMake(51., 31.);
    self.titleNode.style.flexShrink = 1.;
    
    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                              spacing:15.
                                                                       justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                           alignItems: ASStackLayoutAlignItemsCenter
                                                                             children:@[self.titleNode, self.accessoryNode]];
    contentStack.style.flexGrow = 1.;
    contentStack.style.flexShrink = 1.;
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15., 15., 15., 15.) child:contentStack];
}

@end
