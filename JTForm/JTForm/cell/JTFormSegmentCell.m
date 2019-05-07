//
//  JTFormSegmentCell.m
//  JTForm
//
//  Created by dqh on 2019/5/5.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTFormSegmentCell.h"
#import "JTOptionObject.h"

@interface JTFormSegmentCell ()
@property (nonatomic, strong) ASDisplayNode *segmentNode;
@end

@implementation JTFormSegmentCell

- (void)config
{
    [super config];
    
    _segmentNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        UISegmentedControl *segmentControl = [[UISegmentedControl alloc] init];
        [segmentControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        return segmentControl;
    }];
    _segmentNode.backgroundColor = [UIColor greenColor];
}

- (void)update
{
    [super update];
    
    UISegmentedControl *segmentControl = (UISegmentedControl *)self.segmentNode.view;
    segmentControl.enabled = !self.rowDescriptor.disabled;

    BOOL required = self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle;
    self.titleNode.attributedText = [NSAttributedString
                                     attributedStringWithString:[NSString stringWithFormat:@"%@%@",required ? @"*" : @"", self.rowDescriptor.title]
                                     font:self.rowDescriptor.disabled ? [self formCellDisabledTitleFont] : [self formCellTitleFont]
                                     color:self.rowDescriptor.disabled ? [self formCellDisabledTitleColor] : [self formCellTitleColor]
                                     firstWordColor:required ? kJTFormRequiredCellFirstWordColor : nil];
    
    [self updateSegmentedControl:segmentControl];
    segmentControl.selectedSegmentIndex = [self selectedIndex];
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
    
    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                              spacing:15.
                                                                       justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                           alignItems:ASStackLayoutAlignItemsCenter
                                                                             children:@[leftStack, self.segmentNode]];
    self.segmentNode.style.preferredSize = CGSizeMake(kJTFormSegmentedControlItemWidth*self.rowDescriptor.selectorOptions.count, 30);
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15., 15., 15., 15.) child:contentStack];
}

#pragma mark - Target Event

- (void)valueChanged:(UISegmentedControl *)sender
{
    self.rowDescriptor.value = [self.rowDescriptor.selectorOptions objectAtIndex:sender.selectedSegmentIndex];
}

#pragma mark - Helper

- (void)updateSegmentedControl:(UISegmentedControl *)segmentControl
{
    [segmentControl removeAllSegments];
    [self.rowDescriptor.selectorOptions enumerateObjectsUsingBlock:^(JTOptionObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [segmentControl insertSegmentWithTitle:[obj cellText] atIndex:idx animated:NO];
    }];
}

- (NSInteger)selectedIndex
{
    if (self.rowDescriptor.value) {
        for (JTOptionObject *optionObject in self.rowDescriptor.selectorOptions) {
            if ([self.rowDescriptor.value jt_isEqual:optionObject]) {
                return [self.rowDescriptor.selectorOptions indexOfObject:optionObject];
            }
        }
    }
    return UISegmentedControlNoSegment;
}

@end
