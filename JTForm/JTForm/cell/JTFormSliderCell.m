//
//  JTFormSliderCell.m
//  JTForm
//
//  Created by dqh on 2019/5/6.
//  Copyright © 2019 dqh. All rights reserved.
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
        slider.backgroundColor = [UIColor yellowColor];
        [slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        return slider;
    }];
    _sliderNode.backgroundColor = [UIColor yellowColor];
    _steps = 0;
}

- (void)update
{
    [super update];
    
    UISlider *slider = (UISlider *)self.sliderNode.view;
    slider.enabled = !self.rowDescriptor.disabled;
    slider.value = [self.rowDescriptor.value floatValue];
    [self valueChanged:slider];
    _sliderControl = slider;

    BOOL required = self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle;
    self.titleNode.attributedText = [NSAttributedString
                                     attributedStringWithString:[NSString stringWithFormat:@"%@%@",required ? @"*" : @"", self.rowDescriptor.title]
                                     font:self.rowDescriptor.disabled ? [self formCellDisabledTitleFont] : [self formCellTitleFont]
                                     color:self.rowDescriptor.disabled ? [self formCellDisabledTitleColor] : [self formCellTitleColor]
                                     firstWordColor:required ? kJTFormRequiredCellFirstWordColor : nil];
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
                                                                          children:self.imageNode.image ? @[self.imageNode, self.titleNode] : @[self.titleNode]];
    
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
    if (self.steps != 0) {
        sender.value = roundf((sender.value - sender.minimumValue)/(sender.maximumValue - sender.minimumValue)*self.steps)*(sender.maximumValue-sender.minimumValue)/self.steps + sender.minimumValue;
    }
    UIFont *font = self.rowDescriptor.disabled ? [self formCellDisabledContentFont] : [self formCellContentFont];
    UIColor *color = self.rowDescriptor.disabled ? [self formCellDisabledContentColor] : [self formCellContentColor];
    NSString *displayContent = sender.maximumValue > 1 ? [NSString stringWithFormat:@"%.f",sender.value] : [NSString stringWithFormat:@"%.2f",sender.value];
    self.contentNode.attributedText = [NSAttributedString rightAttributedStringWithString:displayContent
                                                                                     font:font
                                                                                    color:color];
    
    self.rowDescriptor.value = @(sender.value);
}

@end
