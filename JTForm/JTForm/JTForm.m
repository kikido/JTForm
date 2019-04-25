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
#import "JTFormNavigationAccessoryView.h"

typedef NS_ENUM (NSUInteger, JTFormRowNavigationDirection) {
    JTFormRowNavigationDirectionPrevious = 0,
    JTFormRowNavigationDirectionNext
};

@interface JTForm () <ASTableDelegate, ASTableDataSource, JTFormDescriptorDelegate>
@property (nonatomic, strong) JTFormDescriptor *formDescriptor;
@property (nonatomic, strong) JTFormNavigationAccessoryView *navigationAccessoryView;

@property (nonatomic, strong) NSNumber *oldBottomTableMargin;
@property (nonatomic, assign) UIEdgeInsets orginTableContentInset;
@property (nonatomic, assign) BOOL firstShowKeyBoard;
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    view.backgroundColor = [UIColor redColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.;
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.;
//}

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
}

- (void)contentSizeCategoryChanged:(NSNotification *)notification
{
    NSLog(@"%@", notification.userInfo);
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (self.tableNode.indexPathForSelectedRow) {
        NSDictionary *keyboardInfo = notification.userInfo;
        CGRect keybordFrame = [keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect convertTableFrame = [self convertRect:self.tableNode.view.frame toView:self.window];
        // 如果该值小于0，就不需要去设置inset和transform
        CGFloat bottomMargin = CGRectGetMaxY(convertTableFrame) - CGRectGetMinY(keybordFrame);
        if (bottomMargin <= 0) {
            return;
        }
        UIEdgeInsets tableContentInset = self.tableNode.contentInset;
        if (!_firstShowKeyBoard) {
            _firstShowKeyBoard = YES;
            _orginTableContentInset = self.tableNode.contentInset;
        }
        // 当tb.min - transform.y小于0时，需要设置一下inset，不然tb顶部的内容会被遮掉
        if (CGRectGetMinY(convertTableFrame) - bottomMargin < 0) {
            tableContentInset.top += bottomMargin;
            self.tableNode.contentInset = tableContentInset;
        }
        if (_oldBottomTableMargin) {
            bottomMargin += [_oldBottomTableMargin doubleValue];
        }

        if (bottomMargin > 0) {
            _oldBottomTableMargin = @(bottomMargin);

            [UIView animateWithDuration:[keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
                self.transform = CGAffineTransformIdentity;
                self.transform = CGAffineTransformMakeTranslation(0, - bottomMargin);
                [self.tableNode scrollToRowAtIndexPath:self.tableNode.indexPathForSelectedRow atScrollPosition:UITableViewScrollPositionNone animated:NO];
            } completion:nil];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.tableNode.contentInset = _orginTableContentInset;
    self.transform = CGAffineTransformIdentity;
    
    _orginTableContentInset = UIEdgeInsetsZero;
    _oldBottomTableMargin = nil;
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
        // fixme
//        [self.tableNode.view endEditing:YES];
    } else {
//        if ([cellNode respondsToSelector:@selector(jtFormCellInputView)]) {
//            UITableViewCell *cell = [tableNode cellForRowAtIndexPath:indexPath];
//            UIView *inputView = [cellNode jtFormCellInputView];
//            if (inputView) {
//                cell.inputView
//                cell.inputView = inputView;
//            }
//        }
    }
    if ([cellNode respondsToSelector:@selector(formCellDidSelected)]) {
        [cellNode formCellDidSelected];
    }
}

- (BOOL)tableNode:(ASTableNode *)tableNode shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
                                      
                                    JTFormRowTypeDate : [JTFormDateCell class],
                                    JTFormRowTypeTime : [JTFormDateCell class],
                                    JTFormRowTypeDateTime : [JTFormDateCell class],
                                    JTFormRowTypeCountDownTimer : [JTFormDateCell class],
                                    JTFormRowTypeDateInline : [JTFormDateCell class],
                                    JTFormRowTypeInlineDatePicker : [JTFormDateInlineCell class]
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


#pragma mark - edit text delegate

- (BOOL)editableTextShouldBeginEditing:(JTRowDescriptor *)row textField:(nullable UITextField *)textField editableTextNode:(nullable ASEditableTextNode *)editableTextNode
{
    JTBaseCell *cell = [row cellInForm];
    cell.selected = YES;
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
    JTBaseCell *currentCell = [self.tableNode nodeForRowAtIndexPath:self.tableNode.indexPathForSelectedRow];
    JTRowDescriptor *currentRow = currentCell.rowDescriptor;
    JTRowDescriptor *nextRow = [self nextRowDescriptorForRow:currentRow direction:direction];
    
    if (nextRow) {
        JTBaseCell *nextCell = [nextRow cellInForm];
        if ([nextCell formCellCanBecomeFirstResponder]){
            nextCell.selected = YES;
            NSIndexPath *indexPath = [self.tableNode indexPathForNode:nextCell];
            [self.tableNode scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
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

@end
