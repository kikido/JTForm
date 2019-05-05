//
//  JTFormStepCounterCell.m
//  JTForm
//
//  Created by dqh on 2019/5/5.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTFormStepCounterCell.h"

@interface JTFormStepCounterCell ()
@property (nonatomic, strong) UIStepper *stepControl;
@property (nonatomic, strong) ASDisplayNode *stepNode;
@end

@implementation JTFormStepCounterCell

- (void)config
{
    [super config];
    
    _stepNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        self.stepControl = [[UIStepper alloc] init];
        [self.stepControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        return self.stepControl;
    }];
    _stepNode.backgroundColor = [UIColor greenColor];
}

- (void)update
{
    [super update];
    
    self.stepControl.enabled = !self.rowDescriptor.disabled;
    
    BOOL required = self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle;
    self.titleNode.attributedText = [NSAttributedString
                                     attributedStringWithString:[NSString stringWithFormat:@"%@%@",required ? @"*" : @"", self.rowDescriptor.title]
                                     font:self.rowDescriptor.disabled ? [self formCellDisabledTitleFont] : [self formCellTitleFont]
                                     color:self.rowDescriptor.disabled ? [self formCellDisabledTitleColor] : [self formCellTitleColor]
                                     firstWordColor:required ? kJTFormRequiredCellFirstWordColor : nil];
    
    self.contentNode.attributedText = [NSAttributedString
                                       rightAttributedStringWithString:[NSString stringWithFormat:@"%@", self.rowDescriptor.value]
                                       font:self.rowDescriptor.disabled ? [self formCellDisabledContentFont] : [self formCellContentFont]
                                       color:self.rowDescriptor.disabled ? [self formCellDisabledContentColor] : [self formCellContentColor]];
    
    self.stepControl.value = [self.rowDescriptor.value doubleValue];
    self.contentNode.backgroundColor = [UIColor yellowColor];
}

- (void)valueChanged:(UIStepper *)sender
{
    self.rowDescriptor.value = @(sender.value);
    self.contentNode.attributedText = [NSAttributedString
                                       rightAttributedStringWithString:[NSString stringWithFormat:@"%@", self.rowDescriptor.value]
                                       font:self.rowDescriptor.disabled ? [self formCellDisabledContentFont] : [self formCellContentFont]
                                       color:self.rowDescriptor.disabled ? [self formCellDisabledContentColor] : [self formCellContentColor]];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASStackLayoutSpec *leftStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                           spacing:10.
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsStart
                                                                          children:self.imageNode.image ? @[self.imageNode, self.titleNode] : @[self.titleNode]];
    
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
    
//    rightStack.style.flexGrow = 1.;


    
    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                              spacing:15.
                                                                       justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                           alignItems:ASStackLayoutAlignItemsCenter
                                                                             children:@[leftStack, rightStack]];
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15., 15., 15., 15.) child:contentStack];
}
@end
