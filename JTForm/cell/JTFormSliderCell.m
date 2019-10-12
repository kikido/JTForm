//
//  JTFormSliderCell.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTFormSliderCell.h"

@interface JTFormSliderCell ()
@property (nonatomic, strong) ASDisplayNode *sliderNode;
@end

@implementation JTFormSliderCell

- (void)config
{
    [super config];
    
    _sliderNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        UISlider *slider = [[UISlider alloc] init];
        [slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        return slider;
    }];
}

- (void)update
{
    [super update];
    
    UISlider *slider = (UISlider *)self.sliderNode.view;
    slider.enabled   = !self.rowDescriptor.disabled;
    slider.value     = [self.rowDescriptor.value floatValue];
    
    if (self.maximumValue) slider.maximumValue = [self.maximumValue floatValue];
    if (self.minimumValue) slider.minimumValue = [self.minimumValue floatValue];
    if (self.steps) {
        NSUInteger steps = [self.steps unsignedIntegerValue];
        slider.value = roundf((slider.value - slider.minimumValue)/(slider.maximumValue - slider.minimumValue)*steps)*(slider.maximumValue-slider.minimumValue)/steps + slider.minimumValue;
    }
    _slider = slider;
}

+ (CGFloat)formCellHeightForRowDescriptor:(JTRowDescriptor *)row
{
    return 100.;
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
    
    ASStackLayoutSpec *topStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                           spacing:10.
                                                                    justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                        alignItems:ASStackLayoutAlignItemsCenter
                                                                          children:@[leftStack, self.contentNode]];
    topStack.style.flexGrow = 1.;
    topStack.style.flexShrink = 1.;
    
    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                              spacing:15.
                                                                       justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                           alignItems:ASStackLayoutAlignItemsStretch
                                                                             children:@[topStack, self.sliderNode]];
    self.sliderNode.style.minHeight = ASDimensionMake(kJTFormSliderMinHeight);
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15., 15., 15., 15.) child:contentStack];
}

#pragma mark - Target Event

- (void)valueChanged:(UISlider *)sender
{
    if (self.steps) {
        NSUInteger steps = [self.steps unsignedIntegerValue];
        sender.value = roundf((sender.value - sender.minimumValue)/(sender.maximumValue - sender.minimumValue)*steps)*(sender.maximumValue-sender.minimumValue)/steps + sender.minimumValue;
    }
    UIFont *font = [self cellContentFont];
    UIColor *color = [self cellContentColor];
    NSString *displayContent = sender.maximumValue > 1 ? [NSString stringWithFormat:@"%.f",sender.value] : [NSString stringWithFormat:@"%.2f",sender.value];
    self.contentNode.attributedText = [NSAttributedString jt_rightAttributedStringWithString:displayContent
                                                                                        font:font
                                                                                       color:color];
    self.rowDescriptor.value = [NSDecimalNumber numberWithFloat:sender.value];
}
@end
