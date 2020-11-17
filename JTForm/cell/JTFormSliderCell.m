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
        return slider;
    }];
}

- (void)update
{
    [super update];
    
    UISlider *slider = (UISlider *)self.sliderNode.view;
    [slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    slider.enabled = !self.rowDescriptor.disabled;
    
    if (self.maximumValue) slider.maximumValue = [self.maximumValue floatValue];
    if (self.minimumValue) slider.minimumValue = [self.minimumValue floatValue];
    slider.value = [self.rowDescriptor.value floatValue];
    if (self.steps) {
        NSUInteger steps = [self.steps unsignedIntegerValue];
        slider.value = roundf((slider.value - slider.minimumValue)/(slider.maximumValue - slider.minimumValue)*steps)*(slider.maximumValue-slider.minimumValue)/steps + slider.minimumValue;
    }
    _slider = slider;
    
    self.contentNode.attributedText = [self _cellDisplayContent];
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
    self.contentNode.attributedText = [self _cellDisplayContent];
    [self.rowDescriptor manualSetValue:[NSDecimalNumber numberWithFloat:sender.value]];
}

- (NSAttributedString *)_cellDisplayContent
{
    UIFont *font = [self cellContentFont];
    UIColor *color = [self cellContentColor];
    NSString *displayContent = self.slider.maximumValue > 1 ? [NSString stringWithFormat:@"%.f", self.slider.value] : [NSString stringWithFormat:@"%.2f",  self.slider.value];
    return [NSAttributedString jt_rightAttributedStringWithString:displayContent font:font color:color];
}

@end
