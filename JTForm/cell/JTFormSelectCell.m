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

@interface JTFormSelectCell () <ASEditableTextNodeDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

/** 因为实在不知道怎么替换当前view的‘inputView’属性，所以当类型为‘JTFormRowTypePickerSelect’时，只能让这个属性成为第一响应者，然后用‘pickerView’属性替换掉它的‘textview.inputView’ */
@property (nonatomic, strong) ASEditableTextNode *tempNode;
/** 如果用了‘self.accessoryType’属性，更替‘contentNode’内容时布局会乱掉。因为不知道怎么改且时间紧张，自己定义一个‘accessoryType’ */
@property (nonatomic, strong) ASImageNode *accessoryNode;

@property (nonatomic, strong) UIPickerView *pickerView;
@end

@implementation JTFormSelectCell

- (void)config
{
    [super config];
    
    _accessoryNode = [[ASImageNode alloc] init];
    _accessoryNode.image = [UIImage imageNamed:@"JTForm.bundle/jt_cell_disclosureIndicator.png"];
}

- (void)update
{
    [super update];
    
    self.imageNode.image = self.rowDescriptor.image;
    self.imageNode.URL = self.rowDescriptor.imageUrl;
    
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypePickerSelect]) {
        _tempNode = [[ASEditableTextNode alloc] init];
        _tempNode.delegate = self;
        _tempNode.scrollEnabled = false;
        _tempNode.style.preferredSize = CGSizeMake(0.01, 0.01);
    }

    BOOL required = self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle;
    self.titleNode.attributedText = [NSAttributedString
                                     attributedStringWithString:[NSString stringWithFormat:@"%@%@",required ? @"*" : @"", self.rowDescriptor.title]
                                     font:self.rowDescriptor.disabled ? [self formCellDisabledTitleFont] : [self formCellTitleFont]
                                     color:self.rowDescriptor.disabled ? [self formCellDisabledTitleColor] : [self formCellTitleColor]
                                     firstWordColor:required ? kJTFormRequiredCellFirstWordColor : nil];
    
    self.contentNode.attributedText = [self cellDisplayContent];
}

- (void)formCellDidSelected
{
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypePushSelect] || [self.rowDescriptor.rowType isEqualToString:JTFormRowTypeMultipleSelect]) {
        UIViewController *controllerToPresent = [self controllerToPresent];
        if (controllerToPresent) {
            NSAssert([controllerToPresent conformsToProtocol:@protocol(JTFormSelectViewControllerDelegate)], @"viewcontroller should implement JTFormSelectViewControllerDelegate protocol");
            UIViewController<JTFormSelectViewControllerDelegate> *selectorViewController = (UIViewController<JTFormSelectViewControllerDelegate> *)controllerToPresent;
            selectorViewController.rowDescriptor = self.rowDescriptor;
            selectorViewController.title = self.rowDescriptor.selectorTitle;
            
            [self.closestViewController.navigationController pushViewController:selectorViewController animated:YES];
        }
        else if (self.rowDescriptor.selectorOptions) {
            JTFormOptionsViewController *optionViewController = [[JTFormOptionsViewController alloc] init];
            optionViewController.rowDescriptor = self.rowDescriptor;
            optionViewController.form = [self findForm];
            optionViewController.title = self.rowDescriptor.selectorTitle;
        
            [self.closestViewController.navigationController pushViewController:optionViewController animated:YES];
        }
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeSheetSelect]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.rowDescriptor.selectorTitle
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertController addAction:[UIAlertAction actionWithTitle:[NSString jt_localizedStringForKey:@"JTForm_Alert_Cancle"]
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil]];
        __weak typeof(self) weakSelf = self;
        [self.rowDescriptor.selectorOptions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = self;
            NSString *selectTitle = [self cellSelectorDisplayTitle:(JTOptionObject *)obj];
            [alertController addAction:[UIAlertAction actionWithTitle:selectTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                strongSelf.rowDescriptor.value = obj;
                strongSelf.contentNode.attributedText = [strongSelf cellDisplayContent];
            }]];
        }];
        [self.closestViewController presentViewController:alertController animated:YES completion:nil];
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeAlertSelect]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.rowDescriptor.selectorTitle
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:[NSString jt_localizedStringForKey:@"JTForm_Alert_Cancle"]
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil]];
        __weak typeof(self) weakSelf = self;
        [self.rowDescriptor.selectorOptions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = self;
            NSString *selectTitle = [self cellSelectorDisplayTitle:(JTOptionObject *)obj];
            [alertController addAction:[UIAlertAction actionWithTitle:selectTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                strongSelf.rowDescriptor.value = obj;
                strongSelf.contentNode.attributedText = [strongSelf cellDisplayContent];
            }]];
        }];
        [self.closestViewController presentViewController:alertController animated:YES completion:nil];
    } else {
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

- (BOOL)formCellCanBecomeFirstResponder
{
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypePickerSelect]) {
        return !self.rowDescriptor.disabled;
    }
    return NO;
}

- (BOOL)formCellBecomeFirstResponder
{
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypePickerSelect]) {
        return [_tempNode becomeFirstResponder];
    }
    return NO;
}

- (void)formCellHighlight
{
    [super formCellHighlight];
}

- (void)formCellUnhighlight
{
    [super formCellUnhighlight];
}

#pragma mark - property

- (UIPickerView *)pickerView
{
    if (_pickerView == nil) {
        _pickerView = [UIPickerView new];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        if (self.rowDescriptor.value) {
            [self.rowDescriptor.selectorOptions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([self.rowDescriptor.value jt_isEqual:obj]) {
                    [self.pickerView selectRow:idx inComponent:0 animated:NO];
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
    return [self.rowDescriptor.selectorOptions[row] cellText];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypePickerSelect]) {
        self.rowDescriptor.value = self.rowDescriptor.selectorOptions[row];
        self.contentNode.attributedText = [self cellDisplayContent];
    }
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

#pragma mark - helper

- (NSAttributedString *)cellDisplayContent
{
    BOOL noValue = false;
    NSString *displayContent = nil;
    
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeMultipleSelect]) {
        // 没有值
        if (!self.rowDescriptor.value || [self.rowDescriptor.value count] == 0) {
            noValue = YES;
            displayContent = self.rowDescriptor.placeHolder;
        } else {
            if (self.rowDescriptor.valueTransformer) {
                // 有值，有‘valueTransformer’
                NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
                NSValueTransformer *valueTransformer = [[self.rowDescriptor.valueTransformer alloc] init];
                displayContent = [valueTransformer transformedValue:[self.rowDescriptor.value cellValue]];
            } else {
                // 有值，没有‘valueTransformer’
                NSMutableArray *descriptionArray = @[].mutableCopy;
                for (NSInteger i = 0; i < [self.rowDescriptor.value count]; i++) {
                    JTOptionObject *selectObject = self.rowDescriptor.value[i];
                    [descriptionArray addObject:[selectObject cellText]];
                }
                displayContent = [descriptionArray componentsJoinedByString:@", "];
            }
        }
    } else {
        if (!self.rowDescriptor.value) {
            noValue = YES;
            displayContent = self.rowDescriptor.placeHolder;
        } else {
            if (self.rowDescriptor.valueTransformer) {
                NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
                NSValueTransformer *valueTransformer = [self.rowDescriptor.valueTransformer new];
                displayContent = [valueTransformer transformedValue:[self.rowDescriptor.value cellText]];
            } else {
                displayContent = [self.rowDescriptor.value cellText];
            }
        }
    }
    if (displayContent.length == 0) {
        return nil;
    }
    
    UIFont *font =
    noValue
    ? ([self formCellPlaceHlderFont])
    : (self.rowDescriptor.disabled ? [self formCellDisabledContentFont] : [self formCellContentFont]);
    UIColor *color =
    noValue
    ? ([self formCellPlaceHolderColor])
    : (self.rowDescriptor.disabled ? [self formCellDisabledContentColor] : [self formCellContentColor]);
    
    return [NSAttributedString rightAttributedStringWithString:displayContent font:font color:color];
}

- (UIViewController *)controllerToPresent
{
    if (self.rowDescriptor.action.viewControllerClass) {
        return [[self.rowDescriptor.action.viewControllerClass alloc] init];
    }
    return nil;
}

- (NSString *)cellSelectorDisplayTitle:(JTOptionObject *)optionObject
{
    NSString *optionTitle = [optionObject cellText];
    if (self.rowDescriptor.valueTransformer) {
        NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
        NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
        NSString * transformValue = [valueTransformer transformedValue:optionTitle];
        if (transformValue) {
            optionTitle = transformValue;
        }
    }
    return optionTitle;
}

- (UIView *)jtFormCellInputView
{
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypePickerSelect]) {
        return self.pickerView;
    }
    return nil;
}


#pragma mark - ASEditableTextNodeDelegate

- (BOOL)editableTextNodeShouldBeginEditing:(ASEditableTextNode *)editableTextNode
{
    editableTextNode.textView.inputView = [self jtFormCellInputView];
    return [self.findForm editableTextShouldBeginEditing:self.rowDescriptor textField:nil editableTextNode:editableTextNode];
}

- (void)editableTextNodeDidBeginEditing:(ASEditableTextNode *)editableTextNode
{
    [self.findForm editableTextDidBeginEditing:self.rowDescriptor textField:nil editableTextNode:editableTextNode];
}

- (void)editableTextNodeDidFinishEditing:(ASEditableTextNode *)editableTextNode
{
    [self.findForm editableTextDidEndEditing:self.rowDescriptor textField:nil editableTextNode:editableTextNode];
}
@end
