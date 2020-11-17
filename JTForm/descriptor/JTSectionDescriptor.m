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
@property (nonatomic, strong) NSLock *allLock;
@property (nonatomic, strong) NSLock *formLock;
@end

@implementation JTSectionDescriptor

@synthesize hidden = _hidden;
@synthesize disabled = _disabled;

- (instancetype)init
{
    if (self = [super init]) {
        _formRows       = @[].mutableCopy;
        _allRows        = @[].mutableCopy;
        _sectionOptions = JTSectionOptionNone;
        _headerHeight   = JTFormDefaultSectionHeaderHeight;
        _footerHeight   = JTFormDefaultSectionFooterHeight;
        _allLock        = [[NSLock alloc] init];
        _formLock       = [[NSLock alloc] init];
        
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
    if (!self.formDescriptor.form || self.hidden) return;
    
    NSUInteger sectionIndex = [self.formDescriptor indexOfSection:object];
    if (sectionIndex == NSNotFound) return;
    
    if ([keyPath isEqualToString:@"formRows"]) {
        NSMutableArray *indexPaths = [NSMutableArray array];
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeInsertion)]) { // insert
            NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:sectionIndex]];
            }];
            [self.formDescriptor.form formRowHasBeenAddedAtIndexPaths:indexPaths];
        }
        else if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeRemoval)]) { // remove
            NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:sectionIndex]];
            }];
            [self.formDescriptor.form formRowHasBeenRemovedAtIndexPaths:indexPaths];
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
    [self.allLock lock];
    [self.allRows removeAllObjects];
    [self.allLock unlock];
    
    [self.formLock lock];
    [[self formRowsArray] removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _formRows.count)]];
    [self.formLock unlock];
    
    // add
    [self addRows:rows];
}

#pragma mark - add row

- (void)addRow:(JTRowDescriptor *)row
{
    [self addRows:@[row]];
}

- (void)addRows:(NSArray<JTRowDescriptor *> *)rows
{
    [self addRows:rows atIndex:_allRows.count];
}

- (void)addRows:(NSArray<JTRowDescriptor *> *)rows beforeRow:(JTRowDescriptor *)beforeRow
{
    NSUInteger index = [self indexOfRow:beforeRow];
    if (index != NSNotFound) {
        [self addRows:rows atIndex:index];
    }
}

- (void)addRows:(NSArray<JTRowDescriptor *> *)rows afterRow:(JTRowDescriptor *)afterRow
{
    NSUInteger index = [self indexOfRow:afterRow];
    if (index != NSNotFound) {
        [self addRows:rows atIndex:index + 1];
    }
}

- (void)addRows:(NSArray<JTRowDescriptor *> *)rows atIndex:(NSUInteger)index
{
    if (!rows || rows.count == 0) {
        return;
    }
    // insert into all rows
    [self _insertRowsIntoAllRows:rows atIndex:index];
    
    // insert into form rows
    __block NSUInteger indexOfStart = NSNotFound;
    [rows enumerateObjectsUsingBlock:^(JTRowDescriptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.hidden == false) {
            indexOfStart = [self indexOfRowAtFormRowsBeforeInsert:obj];
            *stop = true;
        }
    }];
    NSArray<JTRowDescriptor *> *insertRows = [rows objectsAtIndexes:[rows indexesOfObjectsPassingTest:^BOOL(JTRowDescriptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return !obj.hidden;
    }]];
    if (insertRows.count > 0) {
        [self _insertRowsIntoFormRows:insertRows atIndex:indexOfStart];
    }
}

#pragma mark - remove row

- (void)removeRow:(JTRowDescriptor *)row
{
    [self removeRows:@[row]];
}

- (void)removeRows:(NSArray<JTRowDescriptor *> *)rows
{
    [self _removeRowsFromAllRows:rows];
    [rows enumerateObjectsUsingBlock:^(JTRowDescriptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isCellExist] && [obj.cellForDescriptor jt_isFirstResponder]) {
            [obj.cellForDescriptor resignFirstResponder];
            // FIXME: tableNode 是否可以同时存在多个 first responder
            *stop = true;
        }
    }];
    [self _removeRowsFromFormRows:rows];
}

- (void)removeRowAtIndex:(NSUInteger)index
{
    JTRowDescriptor *row = [self rowAtIndex:index];
    [self removeRow:row];
}

- (void)removeRowByTag:(id<NSCopying>)tag
{
    JTRowDescriptor *row = [self.formDescriptor formRowWithTag:tag];
    [self removeRow:row];
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
    [self.formLock lock];
    NSUInteger indexAtForm = [self.formRows indexOfObject:row];
    [self.formLock unlock];
    
    if (indexAtForm == NSNotFound) {
        indexAtForm = [self indexOfRowAtFormRowsBeforeInsert:row];
        [self _insertRowsIntoFormRows:@[row] atIndex:indexAtForm];
    }
}

/**
 * 将单元行从表单中移除
 *
 * @discuss 将单元行从表单中移除，即从 formRows 数组中移除
 */
- (void)hideFormRow:(JTRowDescriptor *)row
{
    if (row.isCellExist && [row.cellForDescriptor jt_isFirstResponder]) {
        [row.cellForDescriptor resignFirstResponder];
    }
    [self _removeRowsFromFormRows:@[row]];
}

#pragma mark - all rows

- (void)_insertRowsIntoAllRows:(NSArray<JTRowDescriptor *> *)rows atIndex:(NSUInteger)index
{
    [rows enumerateObjectsUsingBlock:^(JTRowDescriptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert(![self.allRows containsObject:obj], @"row:%@ already in form", obj);
        obj.sectionDescriptor = self;
        [self.formDescriptor addRowToTagCollection:obj];
    }];

    [self.allLock lock];
    [self.allRows insertObjects:rows atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, rows.count)]];
    [self.allLock unlock];
}

- (void)_removeRowsFromAllRows:(NSArray<JTRowDescriptor *> *)rows
{
    [rows enumerateObjectsUsingBlock:^(JTRowDescriptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.sectionDescriptor = nil;
        [self.formDescriptor removeRowFromTagCollection:obj];
    }];
    [self.allLock lock];
    [self.allRows removeObjectsInArray:rows];
    [self.allLock unlock];
}

#pragma mark - form rows

- (NSMutableArray *)formRowsArray
{
    return [self mutableArrayValueForKey:@"formRows"];
}

- (void)_insertRowsIntoFormRows:(NSArray<JTRowDescriptor *> *)rows atIndex:(NSUInteger)index
{
    [self.formLock lock];
    [[self formRowsArray] insertObjects:rows atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, rows.count)]];
    [self.formLock unlock];
}

- (void)_removeRowsFromFormRows:(NSArray<JTRowDescriptor *> *)rows
{
    [self.formLock lock];
    // FIXME: measure this step
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [rows enumerateObjectsUsingBlock:^(JTRowDescriptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger index = [self.formRows indexOfObject:obj];
        if (index != NSNotFound) {
            [indexSet addIndex:index];
        }
    }];
    // 为了触发 KVO
    [[self formRowsArray] removeObjectsAtIndexes:indexSet];
    [self.formLock unlock];
}

/** 在插入前，查找在 form rows 中插入的位置*/
- (NSUInteger)indexOfRowAtFormRowsBeforeInsert:(JTRowDescriptor *)row
{
    [self.allLock lock];
    NSInteger indexAtAll  = [self.allRows indexOfObject:row];
    [self.allLock unlock];
    
    [self.formLock lock];
    NSUInteger indexAtForm = [self.formRows indexOfObject:row];
    [self.formLock unlock];
    
    if (indexAtForm == NSNotFound && indexAtAll != NSNotFound) {
        while (indexAtForm == NSNotFound && indexAtAll > 0) {
            [self.allLock lock];
            JTRowDescriptor *previousRow = [self.allRows objectAtIndex:--indexAtAll];
            [self.allLock unlock];
            
            [self.formLock lock];
            indexAtForm = [self.formRows indexOfObject:previousRow];
            [self.formLock unlock];
        }
    }
    return indexAtForm == NSNotFound ? 0 : ++indexAtForm;
}

- (NSUInteger)indexOfRow:(JTRowDescriptor *)row
{
    [self.allLock lock];
    NSUInteger index = [self.allRows indexOfObject:row];
    [self.allLock unlock];
    return index;
}

- (JTRowDescriptor *)rowAtIndex:(NSUInteger)index
{
    [self.allLock lock];
    JTRowDescriptor *row = [self.allRows objectAtIndex:index];
    [self.allLock unlock];
    return row;
}

#pragma mark - disabled

- (void)setDisabled:(BOOL)disabled
{
    if (disabled != _disabled) {
        _disabled = disabled;
        if (!self.formDescriptor.form) return;
        
        [self.formRows enumerateObjectsUsingBlock:^(JTRowDescriptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isCellExist) {
                if ([obj.cellForDescriptor jt_isFirstResponder]) {
                    [obj.cellForDescriptor resignFirstResponder];
                }
                [obj updateCell];
            }
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
