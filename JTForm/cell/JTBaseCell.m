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

@implementation JTBaseCell {
    BOOL _jt_firstResponser;
}

static inline JTFormConfigModel * JTFormGetConfigModelFromRow(JTRowDescriptor *row) {
    static Ivar ivar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        const char *name = [@"_configModel" UTF8String];
        ivar = class_getInstanceVariable([JTRowDescriptor class], name);
    });
    return object_getIvar(row, ivar);
}


static inline JTFormConfigModel * JTFormGetConfigModelFromSection(JTSectionDescriptor *section) {
    static Ivar ivar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        const char *name = [@"_configModel" UTF8String];
        ivar = class_getInstanceVariable([JTSectionDescriptor class], name);
    });
    return object_getIvar(section, ivar);
}

static inline JTFormConfigModel * JTFormGetConfigModelFromForm(JTFormDescriptor *form) {
    static Ivar ivar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        const char *name = [@"_configModel" UTF8String];
        ivar = class_getInstanceVariable([JTFormDescriptor class], name);
    });
    return object_getIvar(form, ivar);
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
    self.titleNode.attributedText = [self titleDisplayAttributeString];
}

#pragma mark - responder

- (BOOL)canBecomeFirstResponder
{
    if (self.rowDescriptor.disabled) {
        return false;
    }
    return false;
}

- (BOOL)becomeFirstResponder
{
    if (![self canBecomeFirstResponder]) {
        return false;
    }
    _jt_firstResponser = true;
    return true;
}

- (BOOL)isFirstResponder
{
    return _jt_firstResponser;
}

- (BOOL)canResignFirstResponder
{
    return true;
}

- (BOOL)resignFirstResponder
{
    if (![self canResignFirstResponder]) {
        return false;
    }
    _jt_firstResponser = false;
    return true;
}

- (BOOL)jt_isFirstResponder
{
    return ([self isFirstResponder] || self.hasInlineCell);
}

#pragma mark - layout

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"subclass must override this method `layoutSpecThatFits:`" userInfo:nil];
}

#pragma mark - helper

- (JTForm *)findForm
{
    return (JTForm *)self.rowDescriptor.sectionDescriptor.formDescriptor.form;
}

- (JTFormDescriptor *)findFormDescriptor
{
    return self.rowDescriptor.sectionDescriptor.formDescriptor;
}

- (NSAttributedString *)titleDisplayAttributeString
{
    // 为必录的单元行设置红色的 *
    BOOL required = self.rowDescriptor.required && [self findFormDescriptor].addAsteriskToRequiredRowsTitle;
    NSString *title = [NSString stringWithFormat:@"%@%@", required ? @"*" : @"", self.rowDescriptor.title ? self.rowDescriptor.title : @""];
    NSAttributedString *attString =
    [NSAttributedString jt_attributedStringWithString:title
                                                 font:[self cellTitleFont]
                                                color:[self cellTitleColor]
                                       firstWordColor:required ? kJTFormRequiredCellFirstWordColor : nil];
    return attString;
}

#pragma mark - config
// normal, highlight, disabled
- (UIColor *)cellTitleColor
{
    if (self.rowDescriptor.disabled) {
        return [self _formCellDisabledTitleColor];
    } else if ([self jt_isFirstResponder]) {
        return [self _formCellHigthLightTitleColor];
    } else {
        return [self _formCellTitleColor];
    }
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
    } else if ([self jt_isFirstResponder]) {
        return [self _formCellHighLightTitleFont];
    } else {
        return [self _formCellTitleFont];
    }
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

#pragma mark - config color
//------------------------------
/// @note 优先级 row > section > form
///-----------------------------

- (UIColor *)cellBackgroundColor
{
    JTFormConfigModel *model = JTFormGetConfigModelFromRow(self.rowDescriptor);
    if (model.backgroundColor)  return model.backgroundColor;
    
    model = JTFormGetConfigModelFromSection(self.rowDescriptor.sectionDescriptor);
    if (model.backgroundColor)  return model.backgroundColor;
    
    model = JTFormGetConfigModelFromForm(self.rowDescriptor.sectionDescriptor.formDescriptor);
    if (model.backgroundColor)  return model.backgroundColor;
    
    return kJTFormCellDefaultBackgroundColor;
}

- (UIColor *)_formCellTitleColor
{
    JTFormConfigModel *model = JTFormGetConfigModelFromRow(self.rowDescriptor);
    if (model.titleColor)  return model.titleColor;
    
    model = JTFormGetConfigModelFromSection(self.rowDescriptor.sectionDescriptor);
    if (model.titleColor)  return model.titleColor;
    
    model = JTFormGetConfigModelFromForm(self.rowDescriptor.sectionDescriptor.formDescriptor);
    if (model.titleColor)  return model.titleColor;
    
    return kJTFormCellDefaultTitleColor;
}

- (UIColor *)_formCellHigthLightTitleColor
{
    JTFormConfigModel *model = JTFormGetConfigModelFromRow(self.rowDescriptor);
    if (model.highLightTitleColor)  return model.highLightTitleColor;
    
    model = JTFormGetConfigModelFromSection(self.rowDescriptor.sectionDescriptor);
    if (model.highLightTitleColor)  return model.highLightTitleColor;
    
    model = JTFormGetConfigModelFromForm(self.rowDescriptor.sectionDescriptor.formDescriptor);
    if (model.highLightTitleColor)  return model.highLightTitleColor;
    
    return kJTFormCellHighLightColor;
}

- (UIColor *)_formCellContentColor
{
    JTFormConfigModel *model = JTFormGetConfigModelFromRow(self.rowDescriptor);
    if (model.contentColor)  return model.contentColor;
    
    model = JTFormGetConfigModelFromSection(self.rowDescriptor.sectionDescriptor);
    if (model.contentColor)  return model.contentColor;
    
    model = JTFormGetConfigModelFromForm(self.rowDescriptor.sectionDescriptor.formDescriptor);
    if (model.contentColor)  return model.contentColor;
    
    return kJTFormCellDefaultContentColor;
}

- (UIColor *)_formCellPlaceHolderColor
{
    JTFormConfigModel *model = JTFormGetConfigModelFromRow(self.rowDescriptor);
    if (model.placeHolderColor)  return model.placeHolderColor;
    
    model = JTFormGetConfigModelFromSection(self.rowDescriptor.sectionDescriptor);
    if (model.placeHolderColor)  return model.placeHolderColor;
    
    model = JTFormGetConfigModelFromForm(self.rowDescriptor.sectionDescriptor.formDescriptor);
    if (model.placeHolderColor)  return model.placeHolderColor;
    
    return kJTFormCellDefaultPlaceHolderColor;
}

- (UIColor *)_formCellDisabledTitleColor
{
    JTFormConfigModel *model = JTFormGetConfigModelFromRow(self.rowDescriptor);
    if (model.disabledTitleColor)  return model.disabledTitleColor;
    
    model = JTFormGetConfigModelFromSection(self.rowDescriptor.sectionDescriptor);
    if (model.disabledTitleColor)  return model.disabledTitleColor;
    
    model = JTFormGetConfigModelFromForm(self.rowDescriptor.sectionDescriptor.formDescriptor);
    if (model.disabledTitleColor)  return model.disabledTitleColor;
    
    return kJTFormCellDisabledTitleColor;
}

- (UIColor *)cellDisabledContentColor
{
    JTFormConfigModel *model = JTFormGetConfigModelFromRow(self.rowDescriptor);
    if (model.disabledContentColor)  return model.disabledContentColor;
    
    model = JTFormGetConfigModelFromSection(self.rowDescriptor.sectionDescriptor);
    if (model.disabledContentColor)  return model.disabledContentColor;
    
    model = JTFormGetConfigModelFromForm(self.rowDescriptor.sectionDescriptor.formDescriptor);
    if (model.disabledContentColor)  return model.disabledContentColor;
    
    return kJTFormCellDisabledContentColor;
}

#pragma mark - config font

- (UIFont *)_formCellTitleFont
{
    JTFormConfigModel *model = JTFormGetConfigModelFromRow(self.rowDescriptor);
    if (model.titleFont)  return model.titleFont;
    
    model = JTFormGetConfigModelFromSection(self.rowDescriptor.sectionDescriptor);
    if (model.titleFont)  return model.titleFont;
    
    model = JTFormGetConfigModelFromForm(self.rowDescriptor.sectionDescriptor.formDescriptor);
    if (model.titleFont)  return model.titleFont;
    
    return kJTFormCellDefaultTitleFont;
}

- (UIFont *)_formCellContentFont
{
    JTFormConfigModel *model = JTFormGetConfigModelFromRow(self.rowDescriptor);
    if (model.contentFont)  return model.contentFont;
    
    model = JTFormGetConfigModelFromSection(self.rowDescriptor.sectionDescriptor);
    if (model.contentFont)  return model.contentFont;
    
    model = JTFormGetConfigModelFromForm(self.rowDescriptor.sectionDescriptor.formDescriptor);
    if (model.contentFont)  return model.contentFont;
    
    return kJTFormCellDefaultContentFont;
}

- (UIFont *)_formCellPlaceHlderFont
{
    JTFormConfigModel *model = JTFormGetConfigModelFromRow(self.rowDescriptor);
    if (model.placeHlderFont)  return model.placeHlderFont;
    
    model = JTFormGetConfigModelFromSection(self.rowDescriptor.sectionDescriptor);
    if (model.placeHlderFont)  return model.placeHlderFont;
    
    model = JTFormGetConfigModelFromForm(self.rowDescriptor.sectionDescriptor.formDescriptor);
    if (model.placeHlderFont)  return model.placeHlderFont;
    
    return kJTFormCellDefaultPlaceHolderFont;
}

- (UIFont *)_formCellDisabledTitleFont
{
    JTFormConfigModel *model = JTFormGetConfigModelFromRow(self.rowDescriptor);
    if (model.disabledTitleFont)  return model.disabledTitleFont;
    
    model = JTFormGetConfigModelFromSection(self.rowDescriptor.sectionDescriptor);
    if (model.disabledTitleFont)  return model.disabledTitleFont;
    
    model = JTFormGetConfigModelFromForm(self.rowDescriptor.sectionDescriptor.formDescriptor);
    if (model.disabledTitleFont)  return model.disabledTitleFont;
    
    return kJTFormCellDisabledTitleFont;
}

- (UIFont *)_formCellHighLightTitleFont
{
    JTFormConfigModel *model = JTFormGetConfigModelFromRow(self.rowDescriptor);
    if (model.highLightTitleFont)  return model.highLightTitleFont;
    
    model = JTFormGetConfigModelFromSection(self.rowDescriptor.sectionDescriptor);
    if (model.highLightTitleFont)  return model.highLightTitleFont;
    
    model = JTFormGetConfigModelFromForm(self.rowDescriptor.sectionDescriptor.formDescriptor);
    if (model.highLightTitleFont)  return model.highLightTitleFont;
    
    return kJTFormCellDefaultTitleFont;
}

- (UIFont *)cellDisabledContentFont
{
    JTFormConfigModel *model = JTFormGetConfigModelFromRow(self.rowDescriptor);
    if (model.disabledContentFont)  return model.disabledContentFont;
    
    model = JTFormGetConfigModelFromSection(self.rowDescriptor.sectionDescriptor);
    if (model.disabledContentFont)  return model.disabledContentFont;
    
    model = JTFormGetConfigModelFromForm(self.rowDescriptor.sectionDescriptor.formDescriptor);
    if (model.disabledContentFont)  return model.disabledContentFont;
    
    return kJTFormCellDisabledContentFont;
}

- (void)cellHighLight {}

- (void)cellUnHighLight {}

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


- (NSString *)description
{
    return[NSString stringWithFormat:@"{\orgin:%@\n descriptor:%@\n}\n", [super description], self.rowDescriptor];
}
@end
