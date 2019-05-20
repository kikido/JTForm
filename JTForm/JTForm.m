//
//  JTForm.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTForm.h"
#import "JTBaseCell.h"
#import "JTFormTextFieldCell.h"
#import "JTFormTextViewCell.h"
#import "JTFormSelectCell.h"
#import "JTFormDateCell.h"
#import "JTFormDateInlineCell.h"
#import "JTFromSwitchCell.h"
#import "JTFormSegmentCell.h"
#import "JTFormSliderCell.h"
#import "JTFormFloatTextCell.h"
#import "JTFormCheckCell.h"
#import "JTFormStepCounterCell.h"

#import "JTFormNavigationAccessoryView.h"

typedef NS_ENUM (NSUInteger, JTFormRowNavigationDirection) {
    JTFormRowNavigationDirectionPrevious = 0,
    JTFormRowNavigationDirectionNext
};

typedef NS_ENUM(NSUInteger, JTFormErrorCode) {
    JTFormErrorCodeInvalid = -999,
    JTFormErrorCodeRequired = -1000
};

NSString *const JTFormErrorDomain = @"JTFormErrorDomain";

@interface JTForm () <ASTableDelegate, ASTableDataSource, JTFormDescriptorDelegate>
@property (nonatomic, strong) JTFormNavigationAccessoryView *navigationAccessoryView;

@property (nonatomic, assign) BOOL notFirstShowKeyBoard;
@property (nonatomic, assign) CGRect orginViewControllerFrame;
@property (nonatomic, assign) UIEdgeInsets orginTableContentInset;
/** 代表第一响应者的那一行 */
@property (nonatomic, strong) JTBaseCell *firstResponderCell;
@end

@implementation JTForm

- (instancetype)initWithFormDescriptor:(JTFormDescriptor *)formDescriptor
{
    if (self = [super initWithFrame:CGRectZero]) {
        _formDescriptor = formDescriptor;
        _formDescriptor.delegate = self;
        _showInputAccessoryView = YES;
        

        [self initializeForm];
        [self addNotifications];
    }
    return self;
}

- (void)initializeForm
{
    _tableNode            = [[ASTableNode alloc] initWithStyle:UITableViewStyleGrouped];
    _tableNode.dataSource = self;
    _tableNode.delegate   = self;
    [self addSubnode:_tableNode];
}

- (void)dealloc
{
    self.tableNode.delegate = nil;
    self.tableNode.dataSource = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.window.backgroundColor = [UIColor whiteColor];
    self.tableNode.frame = self.frame;
}

#pragma mark - ASCommonTableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JTSectionDescriptor *sectionDescriptor = [self.formDescriptor formSectionAtIndex:section];
    if (sectionDescriptor.headerView) {
        return sectionDescriptor.headerView;
    }
    if (!sectionDescriptor.headerAttributedString) {
        return nil;
    }
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, sectionDescriptor.headerHeight)];
    header.opaque = YES;
    
    ASTextNode *textNode = [[ASTextNode alloc] init];
    textNode.attributedText = sectionDescriptor.headerAttributedString;
    textNode.frame = CGRectMake(15., 5., self.bounds.size.width - 30., sectionDescriptor.headerHeight - 10.);
    [header addSubnode:textNode];
    
    return header;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    JTSectionDescriptor *sectionDescriptor = [self.formDescriptor formSectionAtIndex:section];
    if (sectionDescriptor.footerView) {
        return sectionDescriptor.footerView;
    }
    if (!sectionDescriptor.footerAttributedString) {
        return nil;
    }
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, sectionDescriptor.footerHeight)];
    footer.opaque = YES;
    
    ASTextNode *textNode = [[ASTextNode alloc] init];
    textNode.attributedText = sectionDescriptor.headerAttributedString;
    textNode.frame = CGRectMake(15., 5., self.bounds.size.width - 30., sectionDescriptor.footerHeight - 10.);
    [footer addSubnode:textNode];
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    JTSectionDescriptor *sectionDescriptor = [self.formDescriptor formSectionAtIndex:section];
    return sectionDescriptor.headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    JTSectionDescriptor *sectionDescriptor = [self.formDescriptor formSectionAtIndex:section];
    return sectionDescriptor.footerHeight;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTSectionDescriptor *section = [self.formDescriptor formSectionAtIndex:indexPath.section];
    if (section.sectionOptions & JTFormSectionOptionCanDelete) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle editStyle = [self tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    if (editStyle == UITableViewCellEditingStyleNone) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        JTRowDescriptor *row = [self.formDescriptor formRowAtIndex:indexPath];
        UITableViewCell *cell = [self.tableNode cellForRowAtIndexPath:indexPath];
        UIView *firstResponder = [cell findFirstResponder];

        if (firstResponder) {
            [self.tableNode.view endEditing:YES];
        }
        [row.sectionDescriptor removeFormRowAtIndex:indexPath.row];
    }
}

#pragma mark - notification

- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentSizeCategoryChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)contentSizeCategoryChanged:(NSNotification *)notification
{
    [self updateAllFormRows];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (_firstResponderCell && self.tableNode.closestViewController && self.showInputAccessoryView && self.tableNode.isVisible) {

        NSDictionary *keyboardInfo = notification.userInfo;
//        CGRect keybordBeginFrame = [keyboardInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect keybordEndFrame = [keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        if (!_notFirstShowKeyBoard) {
            // 第一次弹出键盘
            _notFirstShowKeyBoard = YES;
            _orginTableContentInset = self.tableNode.contentInset;
            _orginViewControllerFrame =  self.tableNode.closestViewController.view.frame;
        }
        self.tableNode.closestViewController.view.transform = CGAffineTransformIdentity;
        CGFloat ty = _orginViewControllerFrame.size.height + _orginViewControllerFrame.origin.y - keybordEndFrame.origin.y;

//        NSLog(@"[JTForm] keybordBeginFrame:%@",NSStringFromCGRect(keybordBeginFrame));
//        NSLog(@"[JTForm] keybordEndFrame:%@",NSStringFromCGRect(keybordEndFrame));
//        NSLog(@"[JTForm] superFrame:%@",NSStringFromCGRect(_orginViewControllerFrame));
//        NSLog(@"[JTForm] real superFrame:%@",NSStringFromCGRect(self.tableNode.closestViewController.view.frame));
//        NSLog(@"[JTForm] ty:%f", ty);

        if (ty > 0) {
            UIEdgeInsets newTableInset = UIEdgeInsetsMake(_orginTableContentInset.top + ty, _orginTableContentInset.left, _orginTableContentInset.bottom, _orginTableContentInset.right);
            [UIView animateWithDuration:[keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
                self.tableNode.contentInset = newTableInset;
                self.tableNode.closestViewController.view.frame = CGRectMake(self.orginViewControllerFrame.origin.x, self.orginViewControllerFrame.origin.y-ty, self.orginViewControllerFrame.size.width, self.orginViewControllerFrame.size.height);
                [self.tableNode scrollToRowAtIndexPath:[self.tableNode indexPathForNode:self.firstResponderCell] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            } completion:nil];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (_notFirstShowKeyBoard) {
        self.tableNode.contentInset = _orginTableContentInset;
        self.tableNode.closestViewController.view.frame = _orginViewControllerFrame;
    }
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    _orginTableContentInset = UIEdgeInsetsZero;
    _notFirstShowKeyBoard = false;
    _orginViewControllerFrame = CGRectZero;
    _firstResponderCell = nil;
}

#pragma mark - JTFormDescriptorDelegate

- (void)formSectionsHaveBeenRemovedAtIndexes:(NSIndexSet *)indexSet
{
    [self.tableNode performBatchUpdates:^{
        [self.tableNode deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    } completion:nil];
}

- (void)formSectionsHaveBeenAddedAtIndexes:(NSIndexSet *)indexSet
{
    [self.tableNode performBatchUpdates:^{
        [self.tableNode insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    } completion:nil];
}

- (void)formRowsHaveBeenAddedAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [self.tableNode performBatchUpdates:^{
        [self.tableNode insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    } completion:nil];
}

- (void)formRowsHaveBeenRemovedAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [self.tableNode performBatchUpdates:^{
        [self.tableNode deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    } completion:nil];
}

#pragma mark - ASTableDataSource

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section
{
    JTSectionDescriptor *sectionDescriptor = self.formDescriptor.formSections[section];
    return sectionDescriptor.formRows.count;
}

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode
{
    return self.formDescriptor.formSections.count;
}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTRowDescriptor *rowDescriptor = [self.formDescriptor formRowAtIndex:indexPath];
    JTBaseCell *cell = [rowDescriptor cellInForm];
    [self upadteCell:cell];
    
    return cell;
}

#pragma mark - ASTableDelegate

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTRowDescriptor *rowDescriptor = [self.formDescriptor formRowAtIndex:indexPath];
    if (rowDescriptor.disabled) {
        return;
    }
    JTBaseCell *cellNode = [rowDescriptor cellInForm];
    if (!([cellNode formCellCanBecomeFirstResponder] && [cellNode formCellBecomeFirstResponder])) {
        [self.tableNode.view endEditing:YES];
    }
    if ([cellNode respondsToSelector:@selector(formCellDidSelected)]) {
        [cellNode formCellDidSelected];
    }
}

- (ASSizeRange)tableNode:(ASTableNode *)tableNode constrainedSizeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTRowDescriptor *row = [self.formDescriptor formRowAtIndex:indexPath];
    if (row.height == JTFormUnspecifiedCellHeight || row.height <= 0) {
        return ASSizeRangeUnconstrained;
    } else {
        return ASSizeRangeMake(CGSizeMake(0, row.height));
    }
}

- (void)tableNode:(ASTableNode *)tableNode willBeginBatchFetchWithContext:(ASBatchContext *)context
{
    if (self.tailDelegate) {
        if ([self.tailDelegate respondsToSelector:@selector(tailLoadWithContent:)]) {
            [context beginBatchFetching];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tailDelegate tailLoadWithContent:context];
            });
        }
    }
}

#pragma mark - cell

- (void)upadteCell:(JTBaseCell *)cell
{
    [cell update];
    [cell.rowDescriptor.cellConfigAfterUpdate enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [cell setValue:obj == [NSNull null] ? nil : obj forKeyPath:key];
    }];
    if (cell.rowDescriptor.disabled) {
        [cell.rowDescriptor.cellConfigWhenDisabled enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [cell setValue:(obj == [NSNull null] ? nil : obj) forKeyPath:key];
        }];
    }
}

#pragma mark - row type

+ (NSMutableDictionary *)cellClassesForRowTypes
{
    static NSMutableDictionary * _cellClassesForRowTypes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cellClassesForRowTypes = @{
                                    JTFormRowTypeText : [JTFormTextFieldCell class],
                                    JTFormRowTypeName : [JTFormTextFieldCell class],
                                    JTFormRowTypeEmail : [JTFormTextFieldCell class],
                                    JTFormRowTypeNumber : [JTFormTextFieldCell class],
                                    JTFormRowTypeInteger : [JTFormTextFieldCell class],
                                    JTFormRowTypeDecimal : [JTFormTextFieldCell class],
                                    JTFormRowTypePassword : [JTFormTextFieldCell class],
                                    JTFormRowTypePhone : [JTFormTextFieldCell class],
                                    JTFormRowTypeURL : [JTFormTextFieldCell class],
                                      
                                    JTFormRowTypeTextView : [JTFormTextViewCell class],
                                    JTFormRowTypeInfo : [JTFormTextViewCell class],
                                      
                                    JTFormRowTypePushSelect : [JTFormSelectCell class],
                                    JTFormRowTypeMultipleSelect : [JTFormSelectCell class],
                                    JTFormRowTypeSheetSelect : [JTFormSelectCell class],
                                    JTFormRowTypeAlertSelect : [JTFormSelectCell class],
                                    JTFormRowTypePickerSelect : [JTFormSelectCell class],
                                    JTFormRowTypePushButton : [JTFormSelectCell class],
                                      
                                    JTFormRowTypeDate : [JTFormDateCell class],
                                    JTFormRowTypeTime : [JTFormDateCell class],
                                    JTFormRowTypeDateTime : [JTFormDateCell class],
                                    JTFormRowTypeCountDownTimer : [JTFormDateCell class],
                                    JTFormRowTypeDateInline : [JTFormDateCell class],
                                    JTFormRowTypeInlineDatePicker : [JTFormDateInlineCell class],
                                    
                                    JTFormRowTypeSwitch : [JTFromSwitchCell class],
                                    JTFormRowTypeCheck : [JTFormCheckCell class],
                                    JTFormRowTypeStepCounter : [JTFormStepCounterCell class],
                                    JTFormRowTypeSegmentedControl : [JTFormSegmentCell class],
                                    JTFormRowTypeSlider : [JTFormSliderCell class],
                                    
                                    JTFormRowTypeFloatText : [JTFormFloatTextCell class]
                                    }.mutableCopy;
    });
    return _cellClassesForRowTypes;
}

#pragma mark - inline row type

+ (NSMutableDictionary *)inlineRowTypesForRowTypes
{
    static NSMutableDictionary *_inlineRowTypesForRowTypes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _inlineRowTypesForRowTypes = @{
                                       JTFormRowTypeDateInline : JTFormRowTypeInlineDatePicker
                                       }.mutableCopy;
    });
    return _inlineRowTypesForRowTypes;
}

- (void)ensureRowIsVisible:(JTRowDescriptor *)rowDescriptor
{
    JTBaseCell *inlineCell = [rowDescriptor cellInForm];
    if (!inlineCell.isVisible) {
        NSIndexPath *indexPath = [self.formDescriptor indexPathForRowDescriptor:rowDescriptor];
        [self.tableNode scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

#pragma mark - edit text delegate

- (BOOL)editableTextShouldBeginEditing:(JTRowDescriptor *)row textField:(nullable UITextField *)textField editableTextNode:(nullable ASEditableTextNode *)editableTextNode
{
    JTBaseCell *cell = [row cellInForm];
    _firstResponderCell = cell;

    if (editableTextNode && self.showInputAccessoryView) {
        editableTextNode.textView.inputAccessoryView = [self inputAccessoryViewForCell:cell];
    } else if (textField && self.showInputAccessoryView) {
        textField.inputAccessoryView = [self inputAccessoryViewForCell:cell];;
    }
    return YES;
}

- (void)editableTextDidBeginEditing:(JTRowDescriptor *)row textField:(nullable UITextField *)textField editableTextNode:(nullable ASEditableTextNode *)editableTextNode
{
    [self beginEditing:row];
}

- (BOOL)editableTextNode:(nullable ASEditableTextNode *)editableTextNode textField:(nullable UITextField *)textField shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)editableTextDidEndEditing:(JTRowDescriptor *)row textField:(nullable UITextField *)textField editableTextNode:(nullable ASEditableTextNode *)editableTextNode
{
    [self endEditing:row];
}

- (void)beginEditing:(JTRowDescriptor *)row
{
    [[row cellInForm] formCellHighlight];
}

- (void)endEditing:(JTRowDescriptor *)row
{
    [[row cellInForm] formCellUnhighlight];
    
}

#pragma mark - navigation

- (JTFormNavigationAccessoryView *)navigationAccessoryView
{
    if (_navigationAccessoryView == nil) {
        _navigationAccessoryView = [JTFormNavigationAccessoryView new];
        _navigationAccessoryView.previousButton.target = self;
        _navigationAccessoryView.previousButton.action = @selector(rowNavigationAction:);
        _navigationAccessoryView.nextButton.target = self;
        _navigationAccessoryView.nextButton.action = @selector(rowNavigationAction:);
        _navigationAccessoryView.doneButton.target = self;
        _navigationAccessoryView.doneButton.action = @selector(rowNavigationDone:);
        _navigationAccessoryView.tintColor = self.tintColor;
    }
    return _navigationAccessoryView;
}

- (void)rowNavigationAction:(UIBarButtonItem *)sender
{
    [self navigateToDirection:sender == self.navigationAccessoryView.nextButton ? JTFormRowNavigationDirectionNext : JTFormRowNavigationDirectionPrevious];
}

- (void)rowNavigationDone:(UIBarButtonItem *)sender
{
    [self.tableNode.view endEditing:YES];
}

- (void)navigateToDirection:(JTFormRowNavigationDirection)direction
{
    JTBaseCell *currentCell = _firstResponderCell;
    JTRowDescriptor *currentRow = currentCell.rowDescriptor;
    JTRowDescriptor *nextRow = [self nextRowDescriptorForRow:currentRow direction:direction];
    
    if (nextRow) {
        JTBaseCell *nextCell = [nextRow cellInForm];
        if ([nextCell formCellCanBecomeFirstResponder]){
            NSIndexPath *indexPath = [self.tableNode indexPathForNode:nextCell];
            [self.tableNode scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            [nextCell formCellBecomeFirstResponder];
        }
    }
}

- (UIView *)inputAccessoryViewForCell:(JTBaseCell *)cell
{
    JTRowDescriptor *currentRow = cell.rowDescriptor;
    if ([[JTForm inlineRowTypesForRowTypes].allKeys containsObject:currentRow.rowType]) {
        return nil;
    }
    if (![cell formCellCanBecomeFirstResponder]) {
        return  nil;
    }
    JTRowDescriptor *previousRow = [self nextRowDescriptorForRow:currentRow direction:JTFormRowNavigationDirectionPrevious];
    JTRowDescriptor *nextRow = [self nextRowDescriptorForRow:currentRow direction:JTFormRowNavigationDirectionNext];
    
    [self.navigationAccessoryView.previousButton setEnabled:previousRow != nil];
    [self.navigationAccessoryView.nextButton setEnabled:nextRow != nil];

    self.navigationAccessoryView.previousButton.enabled = previousRow != nil;
    self.navigationAccessoryView.nextButton.enabled = nextRow != nil;
    
    return self.navigationAccessoryView;
}

- (JTRowDescriptor *)nextRowDescriptorForRow:(JTRowDescriptor *)currentRow direction:(JTFormRowNavigationDirection)direction
{
    if (!currentRow) {
        return nil;
    }
    JTRowDescriptor *nextRow = (direction == JTFormRowNavigationDirectionNext) ? [self.formDescriptor nextRowDescriptorForRow:currentRow] : [self.formDescriptor previousRowDescriptorForRow:currentRow];
    JTBaseCell *cell = [nextRow cellInForm];
    
    if (!nextRow.disabled && [cell formCellCanBecomeFirstResponder]) {
        return nextRow;
    }
    return [self nextRowDescriptorForRow:nextRow direction:direction];
}

#pragma mark - get data

- (NSDictionary *)formValues
{
    NSMutableDictionary *result = @{}.mutableCopy;
    for (JTSectionDescriptor *section in self.formDescriptor.allSections) {
        for (JTRowDescriptor *row in section.allRows) {
            if (row.tag.length > 0) {
                [result setObject:row.value ? row.value : [NSNull null] forKey:row.tag];
            }
        }
    }
    return result.copy;
}

- (NSArray<NSError *> *)formValidationErrors
{
    NSMutableArray *result = @[].mutableCopy;
    
    for (JTSectionDescriptor *section in self.formDescriptor.formSections) {
        for (JTRowDescriptor *row in section.formRows) {
            JTFormValidateObject *vObject = [row doValidate];
            if (vObject && !vObject.valid) {
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey : vObject.errorMsg
                                           };
                NSError *error = [[NSError alloc] initWithDomain:JTFormErrorDomain code:JTFormErrorCodeInvalid userInfo:userInfo];
                [result addObject:error];
            }
        }
    }
    return [result copy];
}

- (void)showFormValidationError:(NSError *)error
{
    if (!error || !self.tableNode.closestViewController) {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString jt_localizedStringForKey:@"error"]
                                                                             message:error.localizedDescription
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:[NSString jt_localizedStringForKey:@"ok"] style:UIAlertActionStyleDefault handler:nil]];
    [self.tableNode.closestViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)showFormValidationError:(NSError *)error withTitle:(NSString*)title
{
    if (!error || !self.tableNode.closestViewController) {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:error.localizedDescription
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:[NSString jt_localizedStringForKey:@"ok"] style:UIAlertActionStyleDefault handler:nil]];
    [self.tableNode.closestViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - update and reload

- (void)updateFormRow:(JTRowDescriptor *)rowDescriptor
{
    JTBaseCell *cell = [rowDescriptor cellInForm];
    [self upadteCell:cell];
}

- (void)updateAllFormRows
{
    for (JTSectionDescriptor *section in self.formDescriptor.formSections) {
        for (JTRowDescriptor *row in section.formRows) {
            JTBaseCell *cell = [row cellInForm];
            [cell update];
        }
    }
}

- (void)reloadFormRow:(JTRowDescriptor *)rowDescriptor
{
    NSIndexPath *indexPath = [self.formDescriptor indexPathForRowDescriptor:rowDescriptor];
    if (indexPath) {
        [rowDescriptor reloadCell];
        [self.tableNode reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)reloadForm
{
    [self.tableNode reloadData];
}

#pragma mark - helper

- (ASTableView *)tableView
{
    return self.tableNode.view;
}

@end
