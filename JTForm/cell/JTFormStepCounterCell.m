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
        UIStepper *stepControl      = [[UIStepper alloc] init];
        stepControl.backgroundColor = [UIColor clearColor];
        return stepControl;
    }];
}

- (void)update
{
    [super update];
    
    UIStepper *stepControl = (UIStepper *)self.stepNode.view;
    [stepControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    stepControl.enabled = !self.rowDescriptor.disabled;
    
    if (self.maximumValue) stepControl.maximumValue = [self.maximumValue doubleValue];
    if (self.minimumValue) stepControl.minimumValue = [self.minimumValue doubleValue];
    stepControl.value = [self.rowDescriptor.value doubleValue];
    self.stepControl = stepControl;
    
    self.contentNode.attributedText =
    [NSAttributedString jt_rightAttributedStringWithString:self.rowDescriptor.value ? [NSString stringWithFormat:@"%@", self.rowDescriptor.value] : nil
                                                      font:[self cellContentFont]
                                                     color:[self cellContentColor]];
}

- (void)valueChanged:(UIStepper *)sender
{
    [self.rowDescriptor manualSetValue:[NSDecimalNumber numberWithDouble:sender.value]];
    self.contentNode.attributedText =
    [NSAttributedString jt_rightAttributedStringWithString:self.rowDescriptor.value ? [NSString stringWithFormat:@"%@", self.rowDescriptor.value] : nil
                                                      font:[self cellContentFont]
                                                     color:[self cellContentColor]];
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
