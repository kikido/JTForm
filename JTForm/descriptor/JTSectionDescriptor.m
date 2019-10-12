//
//  JTSectionDescriptor.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTSectionDescriptor.h"
#import "JTRowDescriptor.h"
#import "JTBaseCell.h"

CGFloat const JTFormDefaultSectionHeaderHeight = 25.;
CGFloat const JTFormDefaultSectionFooterHeight = 25.;

@interface JTSectionDescriptor ()
@property (nonatomic, strong, readwrite) NSMutableArray<JTRowDescriptor *> *formRows;
@property (nonatomic, strong, readwrite) NSMutableArray<JTRowDescriptor *> *allRows;
@end

@implementation JTSectionDescriptor

@synthesize hidden = _hidden;
@synthesize disabled = _disabled;

- (instancetype)init
{
    if (self = [super init]) {
        _formRows       = @[].mutableCopy;
        _allRows        = @[].mutableCopy;
        _sectionOptions = JTFormSectionOptionNone;
        _headerHeight   = JTFormDefaultSectionHeaderHeight;
        _footerHeight   = JTFormDefaultSectionFooterHeight;
        
        [self addObserver:self forKeyPath:@"formRows" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

+ (instancetype)formSection
{
    return [[JTSectionDescriptor alloc] init];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    // 节的三种状态 1 显示在表单中 2 没有添加到表单中 3 在表单中但被隐藏了
    // 2和3两种情况下 return
    if (!self.formDescriptor.delegate || self.hidden) return;
    
    NSUInteger sectionIndex = [self.formDescriptor.formSections indexOfObject:object];
    if (sectionIndex == NSNotFound) return;
    
    if ([keyPath isEqualToString:@"formRows"]) {
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeInsertion)])
        {
            NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            if (indexSet.count != 0)
                [self.formDescriptor.delegate formRowHasBeenAddedAtIndexPath:[NSIndexPath indexPathForRow:indexSet.firstIndex inSection:sectionIndex]];
        }
        else if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeRemoval)])
        {
            NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            if (indexSet.count != 0)
                [self.formDescriptor.delegate formRowHasBeenRemovedAtIndexPath:[NSIndexPath indexPathForRow:indexSet.firstIndex inSection:sectionIndex]];
        }
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"formRows"];
}

#pragma mark - replace rows

- (void)replaceAllRows:(NSArray<JTRowDescriptor *> *)rows
{
    // remove
    [self.allRows enumerateObjectsUsingBlock:^(JTRowDescriptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.formDescriptor removeRowFromTagCollection:obj];
    }];
    [self.allRows removeAllObjects];
    [[self mutableArrayValueForKey:@"formRows"] removeAllObjects];

    // add
    [self addRows:rows];
}

#pragma mark - add row

- (void)addRow:(JTRowDescriptor *)row atIndex:(NSUInteger)index
{
    BOOL result = [self _insertRow:row inAllRowsAtIndex:index];
    if (result) [self evaluateFormRowIsHidden:row];
}

- (void)addRow:(JTRowDescriptor *)row
{
    [self addRow:row atIndex:_allRows.count];
}

- (void)addRows:(NSArray<JTRowDescriptor *> *)rows
{
    [rows enumerateObjectsUsingBlock:^(JTRowDescriptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addRow:obj];
    }];
}

- (void)addRow:(JTRowDescriptor *)row afterRow:(JTRowDescriptor *)afterRow
{
    if (![self.allRows containsObject:row]) {
        NSUInteger afterIndex = [self.allRows indexOfObject:afterRow];;
        [self addRow:row atIndex:afterIndex==NSNotFound ? _allRows.count : afterIndex + 1];
    }
}

- (void)addRow:(JTRowDescriptor *)row beforeRow:(JTRowDescriptor *)beforeRow
{
    if (![self.allRows containsObject:row]) {
        NSUInteger beforeIndex = [self.allRows indexOfObject:beforeRow];;
        [self addRow:row atIndex:beforeIndex==NSNotFound ? _allRows.count : beforeIndex];
    }
}

#pragma mark - remove row

- (void)removeRow:(JTRowDescriptor *)row
{
    [self hideFormRow:row];
    [self _removeRowInAllRows:row];
}

- (void)removeRowAtIndex:(NSUInteger)index
{
    if (index < 0 || index >= _formRows.count) return;
    
    JTRowDescriptor *row = self.formRows[index];
    [self removeRow:row];
}

- (void)removeRowByTag:(NSString *)tag
{
    if (tag) {
        JTRowDescriptor *row = [self.formDescriptor formRowWithTag:tag];
        [self removeRow:row];
    }
}

#pragma mark - hidden or show row

- (void)evaluateFormRowIsHidden:(JTRowDescriptor *)row
{
    if (!row) return;
    
    if (row.hidden) {
        [self hideFormRow:row];
    } else {
        [self showFormRow:row];
    }
}

- (void)showFormRow:(JTRowDescriptor *)row
{
    if ([self.formRows containsObject:row]) return;
    if (![self.allRows containsObject:row]) return;

    NSUInteger indexInForm = NSNotFound;
    NSUInteger indexInAll = [self.allRows indexOfObject:row];
    
    if (indexInAll != NSNotFound) {
        while (indexInForm == NSNotFound && indexInAll > 0) {
            JTRowDescriptor *previousRow = [self.allRows objectAtIndex:--indexInAll];
            indexInForm = [self.formRows indexOfObject:previousRow];
        }
        [self _insertRow:row inFormAtIndex:indexInForm == NSNotFound ? 0 : ++indexInForm];
    }
}

/**
 * 将单元行从表单中移除
 *
 * @discuss 将单元行从表单中移除，即从 formRows 数组中移除
 */
- (void)hideFormRow:(JTRowDescriptor *)row
{
    // 判断单元行是否已创建。如果已创建则放弃第一响应者，并从 table 移除
    if (row.isCellExist) {
        JTBaseCell *cell = [row cellInForm];
        [cell resignFirstResponder];
    }
    [self _removeRowInForm:row];
}

#pragma mark - all rows

- (BOOL)_insertRow:(JTRowDescriptor *)row inAllRowsAtIndex:(NSUInteger)index
{
    if (index == NSNotFound) index = self.allRows.count;
    if (index < 0)           index = 0;
    if (!row)                return false;
    
    if (![self.allRows containsObject:row]) {
        row.sectionDescriptor = self;
        [self.allRows insertObject:row atIndex:index];
        // add tag to tag collection
        [self.formDescriptor addRowToTagCollection:row];
        
        return true;
    }
    return false;
}

- (void)_removeRowInAllRows:(JTRowDescriptor *)row
{
    row.sectionDescriptor = nil;
    [self.allRows removeObject:row];
    [self.formDescriptor removeRowFromTagCollection:row];
}

#pragma mark - form rows

- (void)_insertRow:(JTRowDescriptor *)row inFormAtIndex:(NSUInteger)index
{
    if (index == NSNotFound) index = self.formRows.count;
    if (index < 0)           index = 0;
    
    if (![self.formRows containsObject:row]) {
        [[self mutableArrayValueForKey:@"formRows"] insertObject:row atIndex:index];
    }
}

- (void)_removeRowInForm:(JTRowDescriptor *)row
{
    [[self mutableArrayValueForKey:@"formRows"] removeObject:row];
}

#pragma mark - disabled

- (void)setDisabled:(BOOL)disabled
{
    if (disabled != _disabled) {
        _disabled = disabled;
        if (!self.formDescriptor.delegate) return;
        
        [[(JTForm *)self.formDescriptor.delegate tableView] endEditing:YES];
        
        [self.formRows enumerateObjectsUsingBlock:^(JTRowDescriptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj updateUI];
        }];
    }
}

#pragma mark - hidden

- (void)setHidden:(BOOL)hidden
{
    if (hidden != _hidden) {
        _hidden = hidden;
        [self.formDescriptor evaluateFormSectionIsHidden:self];
    }
}

@end
