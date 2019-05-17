//
//  JTFormStepCounterCell.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTFormStepCounterCell.h"

@interface JTFormStepCounterCell ()
@property (nonatomic, strong) ASDisplayNode *stepNode;
@end

@implementation JTFormStepCounterCell

- (void)config
{
    [super config];
    
    _stepNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        UIStepper *stepControl = [[UIStepper alloc] init];
        stepControl.backgroundColor = [UIColor clearColor];
        [stepControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        return stepControl;
    }];
}

- (void)update
{
    [super update];
    
    self.imageNode.image = self.rowDescriptor.image;
    self.imageNode.URL = self.rowDescriptor.imageUrl;
    
    UIStepper *stepControl = (UIStepper *)self.stepNode.view;
    stepControl.enabled = !self.rowDescriptor.disabled;
    stepControl.value = [self.rowDescriptor.value doubleValue];
    self.stepControl = stepControl;
    
    BOOL required = self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle;
    self.titleNode.attributedText = [NSAttributedString
                                     attributedStringWithString:[NSString stringWithFormat:@"%@%@",required ? @"*" : @"", self.rowDescriptor.title]
                                     font:self.rowDescriptor.disabled ? [self formCellDisabledTitleFont] : [self formCellTitleFont]
                                     color:self.rowDescriptor.disabled ? [self formCellDisabledTitleColor] : [self formCellTitleColor]
                                     firstWordColor:required ? kJTFormRequiredCellFirstWordColor : nil];
    
    self.contentNode.attributedText = [NSAttributedString
                                       rightAttributedStringWithString:self.rowDescriptor.value ? [NSString stringWithFormat:@"%@", self.rowDescriptor.value] : nil
                                       font:self.rowDescriptor.disabled ? [self formCellDisabledContentFont] : [self formCellContentFont]
                                       color:self.rowDescriptor.disabled ? [self formCellDisabledContentColor] : [self formCellContentColor]];
}

- (void)valueChanged:(UIStepper *)sender
{
    self.rowDescriptor.value = @(sender.value);
    self.contentNode.attributedText = [NSAttributedString
                                       rightAttributedStringWithString:self.rowDescriptor.value ? [NSString stringWithFormat:@"%@", self.rowDescriptor.value] : nil
                                       font:self.rowDescriptor.disabled ? [self formCellDisabledContentFont] : [self formCellContentFont]
                                       color:self.rowDescriptor.disabled ? [self formCellDisabledContentColor] : [self formCellContentColor]];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASStackLayoutSpec *leftStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                           spacing:10.
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsCenter
                                                                          children:self.imageNode.hasContent ? @[self.imageNode, self.titleNode] : @[self.titleNode]];
    
    self.titleNode.style.flexGrow = 1.;
    self.titleNode.style.flexShrink = 1.;
    leftStack.style.flexGrow = 1.;
    leftStack.style.flexShrink = 1.;
    
    ASStackLayoutSpec *rightStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                           spacing:10.
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsCenter
                                                                          children:@[self.contentNode, self.stepNode]];
    self.stepNode.style.preferredSize = CGSizeMake(80., 40.);
    self.stepNode.style.spacingAfter = 15.;
    rightStack.style.flexShrink = 1.;
    rightStack.style.alignSelf = ASStackLayoutAlignSelfStretch;
    
    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                              spacing:15.
                                                                       justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                           alignItems:ASStackLayoutAlignItemsCenter
                                                                             children:@[leftStack, rightStack]];
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15., 15., 15., 15.) child:contentStack];
}
@end
