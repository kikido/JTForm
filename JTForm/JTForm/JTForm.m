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
#import "JTFormNavigationAccessoryView.h"

typedef NS_ENUM (NSUInteger, JTFormRowNavigationDirection) {
    JTFormRowNavigationDirectionPrevious = 0,
    JTFormRowNavigationDirectionNext
};

@interface JTForm () <ASTableDelegate, ASTableDataSource, JTFormDescriptorDelegate>
@property (nonatomic, strong) JTFormDescriptor *formDescriptor;
@property (nonatomic, strong) JTFormNavigationAccessoryView *navigationAccessoryView;
@end

@implementation JTForm

//- (instancetype)init
//{
//    @throw [NSException exceptionWithName:NSGenericException reason:@"`-init` unavailable. Use `-formRowDescriptorWithTag:rowType:title:` instead" userInfo:nil];
//    return nil;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    @throw [NSException exceptionWithName:NSGenericException reason:@"`-initWithFrame:` unavailable. Use `-formRowDescriptorWithTag:rowType:title:` instead" userInfo:nil];
//    return nil;
//}
//
//- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    @throw [NSException exceptionWithName:NSGenericException reason:@"`-initWithCoder:` unavailable. Use `-formRowDescriptorWithTag:rowType:title:` instead" userInfo:nil];
//    return nil;
//}


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

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 40.;
//}
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
    JTBaseCell *cell = [self.tableNode nodeForRowAtIndexPath:self.tableNode.indexPathForSelectedRow];

    if (cell) {
        NSDictionary *keyboardInfo = notification.userInfo;
        CGRect keybordFrame = [keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
//        CGRect convertTableFrame = [self.tableView.superview convertRect:self.tableView.frame toView:self.table.window];
//        CGFloat nowBottomMargin = CGRectGetMaxY(convertTableFrame) - CGRectGetMinY(keybordFrame) + (_oldBottomTableMargin ? _oldBottomTableMargin.doubleValue : 0);
//        UIEdgeInsets tableContentInset = self.tableView.contentInset;
//        UIEdgeInsets tableScrollIndicatorInsets = self.tableView.scrollIndicatorInsets;
//        _oldTopTableInset = _oldTopTableInset ?: @(tableContentInset.top);
//
//        if (nowBottomMargin > 0) {
//            _oldBottomTableMargin = @(nowBottomMargin);
//            tableContentInset.top = nowBottomMargin;
//            tableScrollIndicatorInsets.top = nowBottomMargin;
//
//            self.tableView.contentInset = tableContentInset;
//            self.tableView.scrollIndicatorInsets = tableContentInset;
//
//            [UIView animateWithDuration:[keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//                self.transform = CGAffineTransformIdentity;
//                self.transform = CGAffineTransformMakeTranslation(0, -nowBottomMargin);
//
//                NSIndexPath *selectRow = [self.tableView indexPathForCell:cell];
//                [self.tableView scrollToRowAtIndexPath:selectRow atScrollPosition:UITableViewScrollPositionNone animated:NO];
//            } completion:nil];
//        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
//    UIEdgeInsets tableContentInset = self.tableView.contentInset;
//    UIEdgeInsets tableScrollIndicatorInsets = self.tableView.scrollIndicatorInsets;
//
//    tableContentInset.top = [_oldTopTableInset floatValue];
//    tableScrollIndicatorInsets.top = [_oldTopTableInset floatValue];
//    _oldTopTableInset = nil;
//    _oldBottomTableMargin = nil;
//
//    self.tableView.contentInset = tableContentInset;
//    self.tableView.scrollIndicatorInsets = tableScrollIndicatorInsets;
//
//    self.transform = CGAffineTransformIdentity;
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
    
}

//- (ASSizeRange)tableNode:(ASTableNode *)tableNode constrainedSizeForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGSize max = CGSizeMake(0, 200);
//    return ASSizeRangeMake(max);
//}

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

#pragma mark - Cell Classes

+ (NSMutableDictionary *)cellClassesForRowDescriptorTypes
{
    static NSMutableDictionary * _cellClassesForRowDescriptorTypes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cellClassesForRowDescriptorTypes = @{
                                              JTFormRowTypeDefault : [JTDefaultCell class],
                                              JTFormRowTypeText : [JTFormTextFieldCell class]
                                              }.mutableCopy;
    });
    return _cellClassesForRowDescriptorTypes;
}

#pragma mark -  ASEditableTextNodeDelegate

- (BOOL)editableTextNodeShouldBeginEditing:(ASEditableTextNode *)editableTextNode
{
    JTBaseCell *cell = [editableTextNode formCell];
    cell.selected = YES;
    editableTextNode.textView.inputAccessoryView = [self inputAccessoryViewForCell:cell];
    return YES;
}

- (void)editableTextNodeDidBeginEditing:(ASEditableTextNode *)editableTextNode
{
    
}

- (BOOL)editableTextNode:(ASEditableTextNode *)editableTextNode shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)editableTextNodeDidChangeSelection:(ASEditableTextNode *)editableTextNode fromSelectedRange:(NSRange)fromSelectedRange toSelectedRange:(NSRange)toSelectedRange dueToEditing:(BOOL)dueToEditing
{
    
}

- (void)editableTextNodeDidUpdateText:(ASEditableTextNode *)editableTextNode
{
    
}

- (void)editableTextNodeDidFinishEditing:(ASEditableTextNode *)editableTextNode
{
    
}

#pragma mark - edit text

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
    // fixme
//    if ([[JTForm inlineRowDescriptorTypesForRowDescriptorTypes].allKeys containsObject:currentRow.rowType]) {
//        return nil;
//    }
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

@end
