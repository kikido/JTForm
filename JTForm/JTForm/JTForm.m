//
//  JTForm.m
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTForm.h"
#import "JTBaseCell.h"
#import "JTDefaultCell.h"
#import "JTFormTextFieldCell.h"
#import "JTFormTextViewCell.h"
#import "JTFormSelectCell.h"
#import "JTFormDateCell.h"
#import "JTFormDateInlineCell.h"
#import "JTFromSwitchCell.h"
#import "JTFormSegmentCell.h"
#import "JTFormSliderCell.h"
#import "JTFormFloatTextCell.h"

#import "JTFormNavigationAccessoryView.h"
#import "JTFormCheckCell.h"
#import "JTFormStepCounterCell.h"

typedef NS_ENUM (NSUInteger, JTFormRowNavigationDirection) {
    JTFormRowNavigationDirectionPrevious = 0,
    JTFormRowNavigationDirectionNext
};

@interface JTForm () <ASTableDelegate, ASTableDataSource, JTFormDescriptorDelegate>
@property (nonatomic, strong) JTFormNavigationAccessoryView *navigationAccessoryView;

@property (nonatomic, strong) NSNumber *oldBottomTableMargin;
@property (nonatomic, assign) UIEdgeInsets orginTableContentInset;
@property (nonatomic, assign) CGRect orginTableFrame;
@property (nonatomic, assign) BOOL notFirstShowKeyBoard;
@property (nonatomic, strong) NSNumber *oldTopTableInset;
@property (nonatomic, assign) CGFloat temp;
@property (nonatomic, assign) CGRect orginFrame;
/** 代表第一响应者的那一行 */
@property (nonatomic, strong) JTBaseCell *firstResponderCell;
@end

@implementation JTForm

- (instancetype)initWithFormDescriptor:(JTFormDescriptor *)formDescriptor
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.backgroundColor = [UIColor blueColor];
        _formDescriptor = formDescriptor;
        _formDescriptor.delegate = self;
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


// fixme 看看demo是什么时候给frame的
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    _tableNode.frame = self.frame;
}

- (void)dealloc
{
    self.tableNode.delegate = nil;
    self.tableNode.dataSource = nil;
}

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
    footer.backgroundColor = [UIColor greenColor];
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
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardDidShow:)
//                                                 name:UIKeyboardDidShowNotification
//                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)contentSizeCategoryChanged:(NSNotification *)notification
{
    NSLog(@"%@", notification.userInfo);
}

- (void)keyboardWillShow:(NSNotification *)notification
{
//    if (_firstResponderCell) {
//        NSDictionary *keyboardInfo = notification.userInfo;
//        CGRect keybordFrame = [keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        CGRect convertTableFrame = [self convertRect:self.tableNode.view.frame toView:self.window];
//        // 如果该值小于0，就不需要去设置inset和transform
//        CGFloat bottomMargin = CGRectGetMaxY(!_notFirstShowKeyBoard ? convertTableFrame : _orginTableFrame) - CGRectGetMinY(keybordFrame);
//        NSLog(@"form %@",NSStringFromCGRect(convertTableFrame));
//        NSLog(@"keyboard %@",NSStringFromCGRect(keybordFrame));
//        NSLog(@"bottomMargin = %.1f",bottomMargin);
//        if (bottomMargin <= 0 && !_notFirstShowKeyBoard) {
//            return;
//        }
//        UIEdgeInsets tableContentInset = self.tableNode.contentInset;
//        if (!_notFirstShowKeyBoard) {
//            _notFirstShowKeyBoard = YES;
//            _orginTableContentInset = self.tableNode.contentInset;
//            _orginTableFrame = convertTableFrame;
//        }
//        // 当tb.min - transform.y小于0时，需要设置一下inset，不然tb顶部的内容会被遮掉
//        tableContentInset.top = bottomMargin - CGRectGetMinY(_orginTableFrame);
//
////        if (_oldBottomTableMargin) {
////            bottomMargin += [_oldBottomTableMargin doubleValue];
////        }
////
////        _oldBottomTableMargin = @(bottomMargin);
//
//        [UIView animateWithDuration:[keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//
//            self.tableNode.contentInset = tableContentInset;
//            self.transform = CGAffineTransformIdentity;
//            self.transform = CGAffineTransformMakeTranslation(0, -bottomMargin);
//
//
//        } completion:^(BOOL finished) {
//            [self.tableNode scrollToRowAtIndexPath:[self.tableNode indexPathForNode:self.firstResponderCell] atScrollPosition:UITableViewScrollPositionNone animated:NO];
//        }];
//    }
    
    NSDictionary *keyboardInfo = notification.userInfo;
    NSLog(@"userInfo %@",keyboardInfo);
    
    if (_firstResponderCell) {
        CGRect keybordFrame = [keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        UIEdgeInsets tableContentInset = self.tableNode.contentInset;
        if (!_notFirstShowKeyBoard) {
            // 第一次弹出键盘
            _notFirstShowKeyBoard = YES;
            _orginTableContentInset = tableContentInset;
            _orginFrame =  self.tableNode.closestViewController.view.frame;
        }
//        CGRect superFrame = [self.tableNode.closestViewController.view convertRect:self.tableNode.closestViewController.view.frame toView:self.window];
        self.tableNode.closestViewController.view.transform = CGAffineTransformIdentity;
        NSLog(@"[JTForm] superFrame:%@",NSStringFromCGRect(_orginFrame));
        CGFloat ty = _orginFrame.size.height + _orginFrame.origin.y - keybordFrame.origin.y;
        
        if (ty > 0) {
            tableContentInset.top = ty;
            
            [UIView animateWithDuration:[keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
                self.tableNode.contentInset = tableContentInset;
                self.tableNode.closestViewController.view.transform = CGAffineTransformIdentity;
                self.tableNode.closestViewController.view.transform = CGAffineTransformMakeTranslation(0, - ty);
                [self.tableNode scrollToRowAtIndexPath:[self.tableNode indexPathForNode:self.firstResponderCell] atScrollPosition:UITableViewScrollPositionNone animated:NO];
            } completion:nil];
        }
    }
}

//- (void)keyboardDidShow:(NSNotification *)notification
//{
//    NSDictionary *keyboardInfo = notification.userInfo;
//
//    [UIView animateWithDuration:[keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//        self.tableNode.closestViewController.view.transform = CGAffineTransformMakeTranslation(0, - self.temp);
//        [self.tableNode scrollToRowAtIndexPath:[self.tableNode indexPathForNode:self.firstResponderCell] atScrollPosition:UITableViewScrollPositionNone animated:NO];
//    } completion:nil];
//
//    NSLog(@"dddddd");
//}

- (void)keyboardWillHide:(NSNotification *)notification
{
//    self.tableNode.contentInset = _orginTableContentInset;
//    self.transform = CGAffineTransformIdentity;
//
//    _orginTableContentInset = UIEdgeInsetsZero;
//    _oldBottomTableMargin = nil;
//    _notFirstShowKeyBoard = false;
    
    
    NSLog(@"[JTForm] %s", __func__);

    self.tableNode.contentInset = _orginTableContentInset;
    self.tableNode.closestViewController.view.transform = CGAffineTransformIdentity;
    
    _orginTableContentInset = UIEdgeInsetsZero;
    _oldBottomTableMargin = nil;
    _notFirstShowKeyBoard = false;
    _firstResponderCell = nil;
    _orginFrame = CGRectZero;
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
                                    JTFormRowTypeDefault : [JTDefaultCell class],
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
        [self.tableNode scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - edit text delegate

- (BOOL)editableTextShouldBeginEditing:(JTRowDescriptor *)row textField:(nullable UITextField *)textField editableTextNode:(nullable ASEditableTextNode *)editableTextNode
{
    JTBaseCell *cell = [row cellInForm];
    _firstResponderCell = cell;
    NSLog(@"[JTForm] %s", __func__);

    if (editableTextNode) {
        editableTextNode.textView.inputAccessoryView = [self inputAccessoryViewForCell:cell];
    } else {
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
            [self.tableNode scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
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

#pragma mark - 001

- (void)didSelectFormRow:(JTRowDescriptor *)rowDescriptor
{
    NSIndexPath *indexPath = [self.formDescriptor indexPathForRowDescriptor:rowDescriptor];
    if (indexPath) {
        [self.tableNode selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        JTBaseCell *cellNode = [rowDescriptor cellInForm];
        if ([cellNode respondsToSelector:@selector(formCellDidSelected)]) {
            [cellNode formCellDidSelected];
        }
    }
}

- (void)deSelectFormRow:(JTRowDescriptor *)rowDescriptor
{
    NSIndexPath *indexPath = [self.formDescriptor indexPathForRowDescriptor:rowDescriptor];
    if (indexPath) {
        [self.tableNode deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)updateFormRow:(JTRowDescriptor *)rowDescriptor
{
    JTBaseCell *cell = [rowDescriptor cellInForm];
    [self upadteCell:cell];
}

- (void)reloadFormRow:(JTRowDescriptor *)rowDescriptor
{
    NSIndexPath *indexPath = [self.formDescriptor indexPathForRowDescriptor:rowDescriptor];
    if (indexPath) {
        [rowDescriptor reloadCell];
        // fixme 可能有问题
        [self.tableNode reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)reloadForm
{
}

@end
