//
//  JTFormSelectCell.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTFormSelectCell.h"
#import "JTFormOptionsViewController.h"

/** [-imageNode-titleNode-contentNode-accssoryNode-] */

@interface JTFormSelectCell () <ASEditableTextNodeDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

/**
 * 辅助 node
 *
 * 用于 JTFormRowTypePickerSelect 样式的单元行。因为不知道怎么在 cellNode 上面替换自定义的键盘 `inputView`,
 * 所以使用该属性。用 ASEditableTextNode 来充当第一响应者，然后在开始编辑的时候用 UIPickerView 替换掉系统键盘
 */
@property (nonatomic, strong) ASEditableTextNode *tempNode;

/**
 * 用来替代 UITableViewCell 上的 Accessory View
 *
 * @discuss 如果使用 accessoryType 属性，在改变详情的内容时布局会乱掉。
 * 暂时没找到解决方法，先这样子解决一下
 */
@property (nonatomic, strong) ASImageNode *accessoryNode;

@property (nonatomic, strong) UIPickerView *pickerView;
@end

@implementation JTFormSelectCell

- (void)config
{
    [super config];

    _accessoryNode       = [[ASImageNode alloc] init];
    _accessoryNode.image = [UIImage imageNamed:@"JTForm.bundle/jt_cell_disclosureIndicator.png"];
}

- (void)update
{
    [super update];
        
    if (!_tempNode && [self.rowDescriptor.rowType isEqualToString:JTFormRowTypePickerSelect]) {
        _tempNode                     = [[ASEditableTextNode alloc] init];
        _tempNode.delegate            = self;
        _tempNode.scrollEnabled       = false;
        _tempNode.style.preferredSize = CGSizeMake(0.01, 0.01);
    }
    self.contentNode.attributedText = [self _cellDisplayContent];
}

- (void)formCellDidSelected
{
    NSString *rowType = self.rowDescriptor.rowType;
    if ([rowType isEqualToString:JTFormRowTypePushSelect] ||
        [rowType isEqualToString:JTFormRowTypeMultipleSelect])
    {
        UIViewController<JTFormSelectViewControllerDelegate> *controllerToPresent = (UIViewController<JTFormSelectViewControllerDelegate> *)[self controllerToPresent];
        if (controllerToPresent) {
            NSAssert([controllerToPresent conformsToProtocol:@protocol(JTFormSelectViewControllerDelegate)], @"viewcontroller should implement JTFormSelectViewControllerDelegate protocol");
        }
        else if (self.rowDescriptor.selectorOptions) {
            controllerToPresent = [[JTFormOptionsViewController alloc] init];
        }
        controllerToPresent.rowDescriptor = self.rowDescriptor;
        controllerToPresent.form          = [self findForm];
        controllerToPresent.title         = [self _cellSelectTitle];
        [self.closestViewController.navigationController pushViewController:controllerToPresent animated:YES];
    }
    else if ([rowType isEqualToString:JTFormRowTypeSheetSelect] ||
             [rowType isEqualToString:JTFormRowTypeAlertSelect])
    {
        UIAlertControllerStyle alertStyle = [rowType isEqualToString:JTFormRowTypeSheetSelect] ? UIAlertControllerStyleActionSheet: UIAlertControllerStyleAlert;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[self _cellSelectTitle]
                                                                                 message:nil
                                                                          preferredStyle:alertStyle];
        [alertController addAction:[UIAlertAction actionWithTitle:[NSString jt_localizedStringForKey:@"JTForm_Alert_Cancle"]
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil]];
        __weak typeof(self) weakSelf = self;
        [self.rowDescriptor.selectorOptions enumerateObjectsUsingBlock:^(JTOptionObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSString *selectTitle = [strongSelf _selectorDisplayTitle:obj];
            [alertController addAction:[UIAlertAction actionWithTitle:selectTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [strongSelf.rowDescriptor manualSetValue:obj];
                strongSelf.contentNode.attributedText = [strongSelf _cellDisplayContent];
            }]];
        }];
        // 异步任务执行，不然有时候界面出来的特别慢
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.closestViewController presentViewController:alertController animated:YES completion:nil];
        });
    }
    else if ([rowType isEqualToString:JTFormRowTypePickerSelect]) {
        // do nothing
    }
    else
    {
        if (self.rowDescriptor.action.rowBlock) {
            self.rowDescriptor.action.rowBlock(self.rowDescriptor);
        }
    }
    [[self.findForm tableNode] deselectRowAtIndexPath:[self.rowDescriptor.sectionDescriptor.formDescriptor indexPathForRowDescriptor:self.rowDescriptor] animated:YES];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    self.titleNode.style.maxHeight = ASDimensionMake(kJTFormSelectMaxTitleHeight);
    self.titleNode.style.flexShrink = 2.;
    
    NSArray *leftChildren = self.imageNode.hasContent ? (_tempNode ? @[self.imageNode, self.titleNode, _tempNode] : @[self.imageNode, self.titleNode]) : (_tempNode ? @[self.titleNode, _tempNode] : @[self.titleNode]);
    ASStackLayoutSpec *leftStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                           spacing:kJTFormCellImageSpace
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsCenter
                                                                          children:leftChildren];

    
    leftStack.style.flexShrink = 1.;
    
    self.contentNode.style.width = ASDimensionMakeWithFraction(.6);
    self.contentNode.style.maxHeight = ASDimensionMake(kJTFormSelectMaxContentHeight);
    self.contentNode.style.flexGrow = 1.;

    ASStackLayoutSpec *contentStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                              spacing:15.
                                                                       justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                           alignItems: ASStackLayoutAlignItemsCenter
                                                                             children:@[leftStack, self.contentNode]];
    contentStack.style.flexGrow = 1.;
    contentStack.style.flexShrink = 1.;
    
    ASStackLayoutSpec *allStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                          spacing:8.
                                                                   justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                       alignItems: ASStackLayoutAlignItemsCenter
                                                                         children:@[contentStack, _accessoryNode]];
    allStack.style.minHeight = ASDimensionMake(30.);

    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(12., 15., 12., 15.) child:allStack];
}

#pragma mark - responder

- (BOOL)canBecomeFirstResponder
{
    if (!self.rowDescriptor.disabled && [self.rowDescriptor.rowType isEqualToString:JTFormRowTypePickerSelect]) {
        return true;
    }
    return false;
}

- (BOOL)becomeFirstResponder
{
    if ([self canBecomeFirstResponder]) {
        return [_tempNode becomeFirstResponder];
    }
    return false;
}

- (BOOL)isFirstResponder
{
    return [_tempNode isFirstResponder];
}

- (BOOL)canResignFirstResponder
{
    return [_tempNode canResignFirstResponder];
}

- (BOOL)resignFirstResponder
{
    if ([self canResignFirstResponder]) {
        return [_tempNode resignFirstResponder];
    }
    return false;
}

#pragma mark - property

- (UIPickerView *)pickerView
{
    if (_pickerView == nil) {
        _pickerView            = [UIPickerView new];
        _pickerView.delegate   = self;
        _pickerView.dataSource = self;
        
        if (self.rowDescriptor.value) {
            [self.rowDescriptor.selectorOptions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([self.rowDescriptor.value jt_isEqual:obj]) {
                    [self->_pickerView selectRow:idx inComponent:0 animated:NO];
                    *stop = YES;
                }
            }];
        }
    }
    return _pickerView;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self _selectorDisplayTitle:self.rowDescriptor.selectorOptions[row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.rowDescriptor manualSetValue:self.rowDescriptor.selectorOptions[row]];
    self.contentNode.attributedText = [self _cellDisplayContent];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.rowDescriptor.selectorOptions.count;
}

#pragma mark - 

- (NSAttributedString *)_cellDisplayContent
{
    BOOL noValue = false;
    NSString *displayContent = nil;
    
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeMultipleSelect])
    {   // mutable select
        if (!self.rowDescriptor.value || [self.rowDescriptor.value count] == 0) {
            noValue = true;
            displayContent = self.rowDescriptor.placeHolder;
        }
        else {
            if (self.rowDescriptor.valueTransformer) {
                NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
                NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:NSStringFromClass(self.rowDescriptor.valueTransformer)];
                displayContent = [valueTransformer transformedValue:self.rowDescriptor.value];
            } else {
                NSMutableArray *descriptionArray = [NSMutableArray array];
                for (NSInteger i = 0; i < [self.rowDescriptor.value count]; i++) {
                    JTOptionObject *selectObject = self.rowDescriptor.value[i];
                    [descriptionArray addObject:[selectObject descriptionForForm]];
                }
                displayContent = [descriptionArray componentsJoinedByString:@", "];
            }
        }
    }
    else
    {
        if (!self.rowDescriptor.value) {
            noValue = YES;
            displayContent = self.rowDescriptor.placeHolder;
        } else {
            BOOL show = self.rowDescriptor.sectionDescriptor.formDescriptor.noValueShowText;
            
            if (!show && JTIsValueEmpty([self.rowDescriptor.value valueForForm])) {
                noValue = YES;
                displayContent = self.rowDescriptor.placeHolder;
            }
            else if (self.rowDescriptor.valueTransformer) {
                NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
                NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:NSStringFromClass(self.rowDescriptor.valueTransformer)];
                displayContent = [valueTransformer transformedValue:[self.rowDescriptor.value descriptionForForm]];
            }
            else {
                displayContent = [self.rowDescriptor.value descriptionForForm];
            }
        }
    }
    if (displayContent.length == 0) return nil;
    
    UIFont *font = noValue ? [self cellPlaceHolerFont] : [self cellContentFont];
    UIColor *color = noValue ? [self cellPlaceHolerColor] : [self cellContentColor];
    return [NSAttributedString jt_rightAttributedStringWithString:displayContent font:font color:color];
}

- (UIViewController *)controllerToPresent
{
    if (self.rowDescriptor.action.viewControllerClass) {
        return [[self.rowDescriptor.action.viewControllerClass alloc] init];
    }
    return nil;
}

- (NSString *)_selectorDisplayTitle:(JTOptionObject *)optionObject
{
    NSString *optionTitle = [optionObject descriptionForForm];
    if (self.rowDescriptor.valueTransformer) {
        NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]],
                 @"valueTransformer is not a subclass of NSValueTransformer");
        NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:NSStringFromClass(self.rowDescriptor.valueTransformer)];
        NSString *transformtitle = [valueTransformer transformedValue:optionTitle];
        if (transformtitle) {
            optionTitle = transformtitle;
        }
    }
    return optionTitle;
}

- (NSString *)_cellSelectTitle
{
    return self.rowDescriptor.selectorTitle ? self.rowDescriptor.selectorTitle : self.rowDescriptor.title;
}

- (UIView *)_cellInputView
{
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypePickerSelect]) {
        if (!self.rowDescriptor.value && self.rowDescriptor.selectorOptions.count != 0) {
            [self.rowDescriptor manualSetValue:self.rowDescriptor.selectorOptions.firstObject];
            self.contentNode.attributedText = [self _cellDisplayContent];
        }
        return self.pickerView;
    }
    return nil;
}

#pragma mark - ASEditableTextNodeDelegate

- (BOOL)editableTextNodeShouldBeginEditing:(ASEditableTextNode *)editableTextNode
{
    editableTextNode.textView.inputView = [self _cellInputView];
    return YES;
}

- (void)editableTextNodeDidBeginEditing:(ASEditableTextNode *)editableTextNode
{
    [self.findForm beginEditing:self.rowDescriptor];
}

- (void)editableTextNodeDidFinishEditing:(ASEditableTextNode *)editableTextNode
{
    [self.findForm endEditing:self.rowDescriptor];
}

@end
