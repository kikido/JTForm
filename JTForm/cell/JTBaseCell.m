//
//  JTBaseCell.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTBaseCell.h"

@implementation JTBaseCell

- (instancetype)init
{
    if (self = [super init]) {
        [self config];
    }
    return self;
}

- (void)config
{
    self.separatorInset= UIEdgeInsetsMake(0, 15., 0, 0);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.automaticallyManagesSubnodes = YES;
    
    _titleNode = [[ASTextNode alloc] init];
    _titleNode.layerBacked = YES;
    _titleNode.style.flexShrink = 1.;
    
    _contentNode = [[ASTextNode alloc] init];
    _contentNode.layerBacked = YES;
    
    _imageNode = [[JTNetworkImageNode alloc] init];
    _imageNode.layerBacked = YES;
}

- (void)update
{
    self.backgroundColor = [self formCellBgColor];
}

- (void)formCellHighlight
{
    
}

- (void)formCellUnhighlight
{
    
}

- (BOOL)formCellCanBecomeFirstResponder
{
    return NO;
}

- (BOOL)formCellBecomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];
    return result;
}

- (BOOL)formCellResignFirstResponder
{
    BOOL result = [super resignFirstResponder];
    return result;
}

- (BOOL)canBecomeFirstResponder
{
    [super canBecomeFirstResponder];
    return YES;
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    return YES;
}

- (BOOL)canResignFirstResponder
{
    [super canResignFirstResponder];
    return YES;
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    return YES;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"subclass must override this method 'update'" userInfo:nil];
}

#pragma mark - helper

- (UIView *)cellInputView
{
    return nil;
}

- (JTForm *)findForm
{
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.delegate) {
        return (JTForm *)self.rowDescriptor.sectionDescriptor.formDescriptor.delegate;
    } else {
        return nil;
    }
}

- (JTFormDescriptor *)findFormDescriptor
{
    return self.rowDescriptor.sectionDescriptor.formDescriptor;
}

- (JTForm *)jtForm
{
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.delegate) {
        return (JTForm *)self.rowDescriptor.sectionDescriptor.formDescriptor.delegate;
    } else {
        return nil;
    }
}

#pragma mark - config

- (UIColor *)formCellBgColor
{
    if (self.rowDescriptor.configMode.bgColor) {
        return self.rowDescriptor.configMode.bgColor;
    }
    if (self.rowDescriptor.sectionDescriptor.configMode.bgColor) {
        return self.rowDescriptor.sectionDescriptor.configMode.bgColor;
    }
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.bgColor) {
        return self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.bgColor;
    }
    return [UIColor whiteColor];
}

- (UIColor *)formCellTitleColor
{
    if (self.rowDescriptor.configMode.titleColor) {
        return self.rowDescriptor.configMode.titleColor;
    }
    if (self.rowDescriptor.sectionDescriptor.configMode.titleColor) {
        return self.rowDescriptor.sectionDescriptor.configMode.titleColor;
    }
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.titleColor) {
        return self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.titleColor;
    }
    return UIColorHex(333333);
}

- (UIColor *)formCellContentColor
{
    if (self.rowDescriptor.configMode.contentColor) {
        return self.rowDescriptor.configMode.contentColor;
    }
    if (self.rowDescriptor.sectionDescriptor.configMode.contentColor) {
        return self.rowDescriptor.sectionDescriptor.configMode.contentColor;
    }
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.contentColor) {
        return self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.contentColor;
    }
    return UIColorHex(333333);
}

- (UIColor *)formCellPlaceHolderColor
{
    if (self.rowDescriptor.configMode.placeHolderColor) {
        return self.rowDescriptor.configMode.placeHolderColor;
    }
    if (self.rowDescriptor.sectionDescriptor.configMode.placeHolderColor) {
        return self.rowDescriptor.sectionDescriptor.configMode.placeHolderColor;
    }
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.placeHolderColor) {
        return self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.placeHolderColor;
    }
    return UIColorHex(dbdbdb);
}

- (UIColor *)formCellDisabledTitleColor
{
    if (self.rowDescriptor.configMode.disabledTitleColor) {
        return self.rowDescriptor.configMode.disabledTitleColor;
    }
    if (self.rowDescriptor.sectionDescriptor.configMode.disabledTitleColor) {
        return self.rowDescriptor.sectionDescriptor.configMode.disabledTitleColor;
    }
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.disabledTitleColor) {
        return self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.disabledTitleColor;
    }
    return UIColorHex(aaaaaa);
}

- (UIColor *)formCellDisabledContentColor
{
    if (self.rowDescriptor.configMode.disabledContentColor) {
        return self.rowDescriptor.configMode.disabledContentColor;
    }
    if (self.rowDescriptor.sectionDescriptor.configMode.disabledContentColor) {
        return self.rowDescriptor.sectionDescriptor.configMode.disabledContentColor;
    }
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.disabledContentColor) {
        return self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.disabledContentColor;
    }
    return UIColorHex(aaaaaa);
}

- (UIFont *)formCellTitleFont
{
    if (self.rowDescriptor.configMode.titleFont) {
        return self.rowDescriptor.configMode.titleFont;
    }
    if (self.rowDescriptor.sectionDescriptor.configMode.titleFont) {
        return self.rowDescriptor.sectionDescriptor.configMode.titleFont;
    }
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.titleFont) {
        return self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.titleFont;
    }
    return [UIFont systemFontOfSize:16.];
}

- (UIFont *)formCellContentFont
{
    if (self.rowDescriptor.configMode.contentFont) {
        return self.rowDescriptor.configMode.contentFont;
    }
    if (self.rowDescriptor.sectionDescriptor.configMode.contentFont) {
        return self.rowDescriptor.sectionDescriptor.configMode.contentFont;
    }
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.contentFont) {
        return self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.contentFont;
    }
    return [UIFont systemFontOfSize:15.];
}

- (UIFont *)formCellPlaceHlderFont
{
    if (self.rowDescriptor.configMode.placeHlderFont) {
        return self.rowDescriptor.configMode.placeHlderFont;
    }
    if (self.rowDescriptor.sectionDescriptor.configMode.placeHlderFont) {
        return self.rowDescriptor.sectionDescriptor.configMode.placeHlderFont;
    }
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.placeHlderFont) {
        return self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.placeHlderFont;
    }
    return [UIFont systemFontOfSize:15.];
}

- (UIFont *)formCellDisabledTitleFont
{
    if (self.rowDescriptor.configMode.disabledTitleFont) {
        return self.rowDescriptor.configMode.disabledTitleFont;
    }
    if (self.rowDescriptor.sectionDescriptor.configMode.disabledTitleFont) {
        return self.rowDescriptor.sectionDescriptor.configMode.disabledTitleFont;
    }
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.disabledTitleFont) {
        return self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.disabledTitleFont;
    }
    return [UIFont systemFontOfSize:16.];
}

- (UIFont *)formCellDisabledContentFont
{
    if (self.rowDescriptor.configMode.disabledContentFont) {
        return self.rowDescriptor.configMode.disabledContentFont;
    }
    if (self.rowDescriptor.sectionDescriptor.configMode.disabledContentFont) {
        return self.rowDescriptor.sectionDescriptor.configMode.disabledContentFont;
    }
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.disabledContentFont) {
        return self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.disabledContentFont;
    }
    return [UIFont systemFontOfSize:15.];
}

- (UIColor *)highLightTitleColor
{
    return UIColorHex(ff3131);
}


@end
