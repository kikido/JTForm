//
//  JTDefaultCell.m
//  JTForm
//
//  Created by dqh on 2019/4/15.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTDefaultCell.h"

@interface JTDefaultCell ()
@property (nonatomic, strong) ASTextNode *detailTextNode;
@end

@implementation JTDefaultCell

- (void)config
{
    [super config];
    
    _detailTextNode = [[ASTextNode alloc] init];
    _detailTextNode.style.flexShrink = 2.0;
    _detailTextNode.layerBacked = YES;    
}

- (void)update
{
    [super update];
    
//    _imageNode.image = [UIImage imageNamed:@"icon_first_che1"];
    
//    _titleNode.attributedText = [NSAttributedString attributedStringWithString:self.rowDescriptor.title fontSize:15. color:nil firstWordColor:[UIColor jt_colorWithHexString:@"ff3131"]];
//
//    _detailTextNode.attributedText = [NSAttributedString attributedStringWithString:self.rowDescriptor.value fontSize:15. color:nil firstWordColor:[UIColor jt_colorWithHexString:@"ff3131"]];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    
    ASStackLayoutSpec *leftStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                           spacing:10.
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsStart
                                                                          children:self.imageNode.image ? @[self.imageNode, self.titleNode] : @[self.titleNode]];
    leftStack.style.flexGrow = 1;
    
    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                              spacing:15.
                                                                       justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStretch
                                                                             children:@[leftStack, _detailTextNode]];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15., 15., 15., 15.) child:contentStack];
}

#pragma mark - tst

- (void)formCellDidSelected
{
    
}

- (BOOL)formCellCanBecomeFirstResponder
{
    return [self canBecomeFirstResponder];
}

- (BOOL)formCellBecomeFirstResponder
{
    if ([self isFirstResponder]) {
        return [self resignFirstResponder];
    }
//    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    return [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    [super canBecomeFirstResponder];
    return YES;
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    NSLog(@"become");
    return  YES;
//    return [super becomeFirstResponder];
}

- (BOOL)canResignFirstResponder
{
    [super canResignFirstResponder];
    return YES;
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    NSLog(@"resign");
    return YES;
//    return [super resignFirstResponder];
}

@end
