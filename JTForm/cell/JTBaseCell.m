//
//  JTBaseCell.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTBaseCell.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation JTBaseCell

static inline Ivar JTFormRowIvar() {
    static Ivar ivar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        const char *name = [@"_configMode" UTF8String];
        ivar = class_getInstanceVariable([JTRowDescriptor class], name);
    });
    return ivar;
}

static inline Ivar JTFormSectionIvar() {
    static Ivar ivar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        const char *name = [@"_configMode" UTF8String];
        ivar = class_getInstanceVariable([JTSectionDescriptor class], name);
    });
    return ivar;
}

static inline Ivar JTFormIvar() {
    static Ivar ivar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        const char *name = [@"_configMode" UTF8String];
        ivar = class_getInstanceVariable([JTFormDescriptor class], name);
    });
    return ivar;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self config];
    }
    return self;
}

- (void)config
{
    self.separatorInset = UIEdgeInsetsMake(0, 15., 0, 0);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // 根据布局方法 ‘layoutSpecThatFits:’ 来决定添加或者移除 node
    self.automaticallyManagesSubnodes = YES;
}

- (void)update
{
    self.backgroundColor = [self cellBackgroundColor];
    
    // 设置 title image
    if (self.rowDescriptor.image) {
        self.imageNode.image = self.rowDescriptor.image;
    }
    if (self.rowDescriptor.imageUrl) {
        self.imageNode.URL = self.rowDescriptor.imageUrl;
    }
    // 为必录的单元行设置红色的 *
    BOOL required = self.rowDescriptor.required && [self findFormDescriptor].addAsteriskToRequiredRowsTitle;
    self.titleNode.attributedText =
    [NSAttributedString jt_attributedStringWithString:[NSString stringWithFormat:@"%@%@", required ? @"*" : @"", self.rowDescriptor.title]
                                                 font:[self cellTitleFont]
                                                color:[self cellTitleColor]
                                       firstWordColor:required ? kJTFormRequiredCellFirstWordColor : nil];
}

#pragma mark - responder

- (BOOL)cellCanBecomeFirstResponder
{
    return false;
}

- (BOOL)cellBecomeFirstResponder
{
    return false;
}

- (BOOL)canBecomeFirstResponder
{
    [super canBecomeFirstResponder];
    return false;
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    return false;
}

- (BOOL)isFirstResponder
{
    return [super isFirstResponder];
}

- (BOOL)canResignFirstResponder
{
    [super canResignFirstResponder];
    return true;
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    return true;
}

#pragma mark - layout

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"subclass must override this method layoutSpecThatFits：" userInfo:nil];
}

#pragma mark - helper

- (JTForm *)findForm
{
    return (JTForm *)self.rowDescriptor.sectionDescriptor.formDescriptor.delegate;
}

- (JTFormDescriptor *)findFormDescriptor
{
    return self.rowDescriptor.sectionDescriptor.formDescriptor;
}

#pragma mark - config

- (UIColor *)cellTitleColor
{
    if (self.rowDescriptor.disabled) {
        return [self _formCellDisabledTitleColor];
    }
    return [self _formCellTitleColor];
}

- (UIColor *)cellContentColor
{
    if (self.rowDescriptor.disabled) {
        return [self cellDisabledContentColor];
    }
    return [self _formCellContentColor];
}

- (UIColor *)cellPlaceHolerColor
{
    return [self _formCellPlaceHolderColor];
}

- (UIFont *)cellTitleFont
{
    if (self.rowDescriptor.disabled) {
        return [self _formCellDisabledTitleFont];
    }
    return [self _formCellTitleFont];
}

- (UIFont *)cellContentFont
{
    if (self.rowDescriptor.disabled) {
        return [self cellDisabledContentFont];
    }
    return [self _formCellContentFont];
}

- (UIFont *)cellPlaceHolerFont
{
    return [self _formCellPlaceHlderFont];
}


- (UIColor *)cellBackgroundColor
{
    Ivar rowIvar = JTFormRowIvar();
    JTFormConfigMode *rowMode = object_getIvar(self.rowDescriptor, rowIvar);
    if (rowMode.placeHlderFont)  return rowMode.backgroundColor;
    
    Ivar sectionIvar = JTFormSectionIvar();
    JTFormConfigMode *sectionMode = object_getIvar(self.rowDescriptor.sectionDescriptor, sectionIvar);
    if (sectionMode.placeHlderFont)  return sectionMode.backgroundColor;
    
    Ivar formIvar = JTFormIvar();
    JTFormConfigMode *formMode = object_getIvar(self.rowDescriptor.sectionDescriptor.formDescriptor, formIvar);
    if (formMode.placeHlderFont)  return formMode.backgroundColor;
    
    return [UIColor whiteColor];
}

#pragma mark -

- (UIColor *)_formCellTitleColor
{
    // 优先级 row > section > form
    Ivar rowIvar = JTFormRowIvar();
    JTFormConfigMode *rowMode = object_getIvar(self.rowDescriptor, rowIvar);
    if (rowMode.placeHlderFont)  return rowMode.titleColor;
    
    Ivar sectionIvar = JTFormSectionIvar();
    JTFormConfigMode *sectionMode = object_getIvar(self.rowDescriptor.sectionDescriptor, sectionIvar);
    if (sectionMode.placeHlderFont)  return sectionMode.titleColor;
    
    Ivar formIvar = JTFormIvar();
    JTFormConfigMode *formMode = object_getIvar(self.rowDescriptor.sectionDescriptor.formDescriptor, formIvar);
    if (formMode.placeHlderFont)  return formMode.titleColor;
    
    return UIColorHex(333333);
}

- (UIColor *)_formCellContentColor
{
    Ivar rowIvar = JTFormRowIvar();
    JTFormConfigMode *rowMode = object_getIvar(self.rowDescriptor, rowIvar);
    if (rowMode.placeHlderFont)  return rowMode.contentColor;
    
    Ivar sectionIvar = JTFormSectionIvar();
    JTFormConfigMode *sectionMode = object_getIvar(self.rowDescriptor.sectionDescriptor, sectionIvar);
    if (sectionMode.placeHlderFont)  return sectionMode.contentColor;
    
    Ivar formIvar = JTFormIvar();
    JTFormConfigMode *formMode = object_getIvar(self.rowDescriptor.sectionDescriptor.formDescriptor, formIvar);
    if (formMode.placeHlderFont)  return formMode.contentColor;
    
    return UIColorHex(333333);
}

- (UIColor *)_formCellPlaceHolderColor
{
    Ivar rowIvar = JTFormRowIvar();
    JTFormConfigMode *rowMode = object_getIvar(self.rowDescriptor, rowIvar);
    if (rowMode.placeHlderFont)  return rowMode.placeHolderColor;
    
    Ivar sectionIvar = JTFormSectionIvar();
    JTFormConfigMode *sectionMode = object_getIvar(self.rowDescriptor.sectionDescriptor, sectionIvar);
    if (sectionMode.placeHlderFont)  return sectionMode.placeHolderColor;
    
    Ivar formIvar = JTFormIvar();
    JTFormConfigMode *formMode = object_getIvar(self.rowDescriptor.sectionDescriptor.formDescriptor, formIvar);
    if (formMode.placeHlderFont)  return formMode.placeHolderColor;
    
    return UIColorHex(dbdbdb);
}

- (UIColor *)_formCellDisabledTitleColor
{
    Ivar rowIvar = JTFormRowIvar();
    JTFormConfigMode *rowMode = object_getIvar(self.rowDescriptor, rowIvar);
    if (rowMode.placeHlderFont)  return rowMode.disabledTitleColor;
    
    Ivar sectionIvar = JTFormSectionIvar();
    JTFormConfigMode *sectionMode = object_getIvar(self.rowDescriptor.sectionDescriptor, sectionIvar);
    if (sectionMode.placeHlderFont)  return sectionMode.disabledTitleColor;
    
    Ivar formIvar = JTFormIvar();
    JTFormConfigMode *formMode = object_getIvar(self.rowDescriptor.sectionDescriptor.formDescriptor, formIvar);
    if (formMode.placeHlderFont)  return formMode.disabledTitleColor;
    
    return UIColorHex(aaaaaa);
}

- (UIColor *)cellDisabledContentColor
{
    Ivar rowIvar = JTFormRowIvar();
    JTFormConfigMode *rowMode = object_getIvar(self.rowDescriptor, rowIvar);
    if (rowMode.placeHlderFont)  return rowMode.disabledContentColor;
    
    Ivar sectionIvar = JTFormSectionIvar();
    JTFormConfigMode *sectionMode = object_getIvar(self.rowDescriptor.sectionDescriptor, sectionIvar);
    if (sectionMode.placeHlderFont)  return sectionMode.disabledContentColor;
    
    Ivar formIvar = JTFormIvar();
    JTFormConfigMode *formMode = object_getIvar(self.rowDescriptor.sectionDescriptor.formDescriptor, formIvar);
    if (formMode.placeHlderFont)  return formMode.disabledContentColor;
    
    return UIColorHex(aaaaaa);
}

- (UIFont *)_formCellTitleFont
{
    Ivar rowIvar = JTFormRowIvar();
    JTFormConfigMode *rowMode = object_getIvar(self.rowDescriptor, rowIvar);
    if (rowMode.placeHlderFont)  return rowMode.titleFont;
    
    Ivar sectionIvar = JTFormSectionIvar();
    JTFormConfigMode *sectionMode = object_getIvar(self.rowDescriptor.sectionDescriptor, sectionIvar);
    if (sectionMode.placeHlderFont)  return sectionMode.titleFont;
    
    Ivar formIvar = JTFormIvar();
    JTFormConfigMode *formMode = object_getIvar(self.rowDescriptor.sectionDescriptor.formDescriptor, formIvar);
    if (formMode.placeHlderFont)  return formMode.titleFont;
    
    return [UIFont systemFontOfSize:16.];
}

- (UIFont *)_formCellContentFont
{
    Ivar rowIvar = JTFormRowIvar();
    JTFormConfigMode *rowMode = object_getIvar(self.rowDescriptor, rowIvar);
    if (rowMode.placeHlderFont)  return rowMode.contentFont;
    
    Ivar sectionIvar = JTFormSectionIvar();
    JTFormConfigMode *sectionMode = object_getIvar(self.rowDescriptor.sectionDescriptor, sectionIvar);
    if (sectionMode.placeHlderFont)  return sectionMode.contentFont;
    
    Ivar formIvar = JTFormIvar();
    JTFormConfigMode *formMode = object_getIvar(self.rowDescriptor.sectionDescriptor.formDescriptor, formIvar);
    if (formMode.placeHlderFont)  return formMode.contentFont;
    
    return [UIFont systemFontOfSize:15.];
}

- (UIFont *)_formCellPlaceHlderFont
{
    Ivar rowIvar = JTFormRowIvar();
    JTFormConfigMode *rowMode = object_getIvar(self.rowDescriptor, rowIvar);
    if (rowMode.placeHlderFont)  return rowMode.placeHlderFont;
    
    Ivar sectionIvar = JTFormSectionIvar();
    JTFormConfigMode *sectionMode = object_getIvar(self.rowDescriptor.sectionDescriptor, sectionIvar);
    if (sectionMode.placeHlderFont)  return sectionMode.placeHlderFont;
    
    Ivar formIvar = JTFormIvar();
    JTFormConfigMode *formMode = object_getIvar(self.rowDescriptor.sectionDescriptor.formDescriptor, formIvar);
    if (formMode.placeHlderFont)  return formMode.placeHlderFont;
    
    return [UIFont systemFontOfSize:15.];
}

- (UIFont *)_formCellDisabledTitleFont
{
    Ivar rowIvar = JTFormRowIvar();
    JTFormConfigMode *rowMode = object_getIvar(self.rowDescriptor, rowIvar);
    if (rowMode.placeHlderFont)  return rowMode.disabledTitleFont;
    
    Ivar sectionIvar = JTFormSectionIvar();
    JTFormConfigMode *sectionMode = object_getIvar(self.rowDescriptor.sectionDescriptor, sectionIvar);
    if (sectionMode.placeHlderFont)  return sectionMode.disabledTitleFont;
    
    Ivar formIvar = JTFormIvar();
    JTFormConfigMode *formMode = object_getIvar(self.rowDescriptor.sectionDescriptor.formDescriptor, formIvar);
    if (formMode.placeHlderFont)  return formMode.disabledTitleFont;
    
    return [UIFont systemFontOfSize:16.];
}

- (UIFont *)cellDisabledContentFont
{
    Ivar rowIvar = JTFormRowIvar();
    JTFormConfigMode *rowMode = object_getIvar(self.rowDescriptor, rowIvar);
    if (rowMode.placeHlderFont)  return rowMode.disabledContentFont;
    
    Ivar sectionIvar = JTFormSectionIvar();
    JTFormConfigMode *sectionMode = object_getIvar(self.rowDescriptor.sectionDescriptor, sectionIvar);
    if (sectionMode.placeHlderFont)  return sectionMode.disabledContentFont;
    
    Ivar formIvar = JTFormIvar();
    JTFormConfigMode *formMode = object_getIvar(self.rowDescriptor.sectionDescriptor.formDescriptor, formIvar);
    if (formMode.placeHlderFont)  return formMode.disabledContentFont;
    
    return [UIFont systemFontOfSize:15.];
}

- (void)cellHighLight
{
    NSMutableAttributedString *title = [self.titleNode.attributedText mutableCopy];
    [title addAttribute:NSForegroundColorAttributeName
                  value:kJTFormHighLightColor
                  range:[title.string containsString:@"*"] ? NSMakeRange(1, title.length-1) : NSMakeRange(0, title.length)];
    self.titleNode.attributedText = [title copy];
}

- (void)cellUnHighLight
{
    NSMutableAttributedString *title = [self.titleNode.attributedText mutableCopy];
    [title addAttribute:NSForegroundColorAttributeName
                  value:[self cellTitleColor]
                  range:[title.string containsString:@"*"] ? NSMakeRange(1, title.length-1) : NSMakeRange(0, title.length)];
    self.titleNode.attributedText = [title copy];
}

#pragma mark - lazy load

- (ASTextNode *)titleNode
{
    if (!_titleNode) {
        _titleNode                  = [[ASTextNode alloc] init];
        _titleNode.layerBacked      = YES;
        _titleNode.style.flexShrink = 1.;
    }
    return _titleNode;
}

- (ASTextNode *)contentNode
{
    if (!_contentNode) {
        _contentNode             = [[ASTextNode alloc] init];
        _contentNode.layerBacked = YES;
    }
    return _contentNode;
}

- (JTNetworkImageNode *)imageNode
{
    if (!_imageNode) {
        _imageNode             = [[JTNetworkImageNode alloc] init];
        _imageNode.layerBacked = YES;
    }
    return _imageNode;
}

@end
