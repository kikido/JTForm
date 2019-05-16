//
//  JTBaseCell.m
//  JTForm
//
//  Created by dqh on 2019/4/10.
//  Copyright © 2019 dqh. All rights reserved.
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
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.bgColor) {
        if (self.rowDescriptor.sectionDescriptor.configMode.bgColor) {
            if (self.rowDescriptor.configMode.bgColor) {
                return self.rowDescriptor.configMode.bgColor;
            } else {
                return self.rowDescriptor.sectionDescriptor.configMode.bgColor;
            }
        } else {
            return self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.bgColor;
        }
    } else {
        return [UIColor whiteColor];
    }
}

- (UIColor *)formCellTitleColor
{
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.titleColor) {
        if (self.rowDescriptor.sectionDescriptor.configMode.titleColor) {
            if (self.rowDescriptor.configMode.titleColor) {
                return self.rowDescriptor.configMode.titleColor;
            } else {
                return self.rowDescriptor.sectionDescriptor.configMode.titleColor;
            }
        } else {
            return self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.titleColor;
        }
    } else {
        return UIColorHex(333333);
    }
}

- (UIColor *)formCellContentColor
{
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.contentColor) {
        if (self.rowDescriptor.sectionDescriptor.configMode.contentColor) {
            if (self.rowDescriptor.configMode.contentColor) {
                return self.rowDescriptor.configMode.contentColor;
            } else {
                return self.rowDescriptor.sectionDescriptor.configMode.contentColor;
            }
        } else {
            return self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.contentColor;
        }
    } else {
        return UIColorHex(333333);
    }
}

- (UIColor *)formCellPlaceHolderColor
{
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.placeHolderColor) {
        if (self.rowDescriptor.sectionDescriptor.configMode.placeHolderColor) {
            if (self.rowDescriptor.configMode.placeHolderColor) {
                return self.rowDescriptor.configMode.placeHolderColor;
            } else {
                return self.rowDescriptor.sectionDescriptor.configMode.placeHolderColor;
            }
        } else {
            return self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.placeHolderColor;
        }
    } else {
        return UIColorHex(999999);
    }
}

- (UIColor *)formCellDisabledTitleColor
{
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.disabledTitleColor) {
        if (self.rowDescriptor.sectionDescriptor.configMode.disabledTitleColor) {
            if (self.rowDescriptor.configMode.disabledTitleColor) {
                return self.rowDescriptor.configMode.disabledTitleColor;
            } else {
                return self.rowDescriptor.sectionDescriptor.configMode.disabledTitleColor;
            }
        } else {
            return self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.disabledTitleColor;
        }
    } else {
        return UIColorHex(dfdfdf);
    }
}

- (UIColor *)formCellDisabledContentColor
{
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.disabledContentColor) {
        if (self.rowDescriptor.sectionDescriptor.configMode.disabledContentColor) {
            if (self.rowDescriptor.configMode.disabledContentColor) {
                return self.rowDescriptor.configMode.disabledContentColor;
            } else {
                return self.rowDescriptor.sectionDescriptor.configMode.disabledContentColor;
            }
        } else {
            return self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.disabledContentColor;
        }
    } else {
        return UIColorHex(dbdbdb);
    }
}

- (UIFont *)formCellTitleFont
{
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.titleFont) {
        if (self.rowDescriptor.sectionDescriptor.configMode.titleFont) {
            if (self.rowDescriptor.configMode.titleFont) {
                return self.rowDescriptor.configMode.titleFont;
            } else {
                return self.rowDescriptor.sectionDescriptor.configMode.titleFont;
            }
        } else {
            return self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.titleFont;
        }
    } else {
        return [UIFont systemFontOfSize:15.];
    }
}

- (UIFont *)formCellContentFont
{
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.contentFont) {
        if (self.rowDescriptor.sectionDescriptor.configMode.contentFont) {
            if (self.rowDescriptor.configMode.contentFont) {
                return self.rowDescriptor.configMode.contentFont;
            } else {
                return self.rowDescriptor.sectionDescriptor.configMode.contentFont;
            }
        } else {
            return self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.contentFont;
        }
    } else {
        return [UIFont systemFontOfSize:15.];
    }
}

- (UIFont *)formCellPlaceHlderFont
{
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.placeHlderFont) {
        if (self.rowDescriptor.sectionDescriptor.configMode.placeHlderFont) {
            if (self.rowDescriptor.configMode.placeHlderFont) {
                return self.rowDescriptor.configMode.placeHlderFont;
            } else {
                return self.rowDescriptor.sectionDescriptor.configMode.placeHlderFont;
            }
        } else {
            return self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.placeHlderFont;
        }
    } else {
        return [UIFont systemFontOfSize:15.];
    }
}

- (UIFont *)formCellDisabledTitleFont
{
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.disabledTitleFont) {
        if (self.rowDescriptor.sectionDescriptor.configMode.disabledTitleFont) {
            if (self.rowDescriptor.configMode.disabledTitleFont) {
                return self.rowDescriptor.configMode.disabledTitleFont;
            } else {
                return self.rowDescriptor.sectionDescriptor.configMode.disabledTitleFont;
            }
        } else {
            return self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.disabledTitleFont;
        }
    } else {
        return [UIFont systemFontOfSize:15.];
    }
}

- (UIFont *)formCellDisabledContentFont
{
    if (self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.disabledContentFont) {
        if (self.rowDescriptor.sectionDescriptor.configMode.disabledContentFont) {
            if (self.rowDescriptor.configMode.disabledContentFont) {
                return self.rowDescriptor.configMode.disabledContentFont;
            } else {
                return self.rowDescriptor.sectionDescriptor.configMode.disabledContentFont;
            }
        } else {
            return self.rowDescriptor.sectionDescriptor.formDescriptor.configMode.disabledContentFont;
        }
    } else {
        return [UIFont systemFontOfSize:15.];
    }
}

- (UIColor *)highLightTitleColor
{
    return UIColorHex(ff3131);
}


@end
