//
//  JTSectionDescriptor.m
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTSectionDescriptor.h"
#import "JTFormDescriptor.h"

@interface JTSectionDescriptor ()
@property (nonatomic, strong, readwrite) NSMutableArray *formRows;
@property (nonatomic, strong, readwrite) NSMutableArray *allRows;
@end

@implementation JTSectionDescriptor

- (instancetype)init
{
    if (self = [super init]) {
        _formRows = @[].mutableCopy;
        _allRows = @[].mutableCopy;
        
        _footerHeight = 30.;
        _headerHeight = 30.;
        
        [self addObserver:self forKeyPath:@"formRows" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionOld context:nil];
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
    // fixme 还没确认好时机
    if (!self.formDescriptor.delegate) {
        return;
    }
    if ([keyPath isEqualToString:@"formRows"]) {
        if ([self.formDescriptor.formSections containsObject:self]) {            
            if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeInsertion)])
            {
                NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
                JTRowDescriptor *formRow = [((JTSectionDescriptor *)object).formRows objectAtIndex:indexSet.firstIndex];
                NSUInteger sectionIndex = [self.formDescriptor.formSections indexOfObject:object];
                [self.formDescriptor.delegate formRowHasBeenAdded:formRow atIndexPath:[NSIndexPath indexPathForRow:indexSet.firstIndex inSection:sectionIndex]];
            }
            else if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeRemoval)])
            {
                NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
                JTRowDescriptor *removedRow = [[change objectForKey:NSKeyValueChangeOldKey] objectAtIndex:0];
                NSUInteger sectionIndex = [self.formDescriptor.formSections indexOfObject:object];
                [self.formDescriptor.delegate formRowHasBeenRemoved:removedRow atIndexPath:[NSIndexPath indexPathForRow:indexSet.firstIndex inSection:sectionIndex]];
            }
        }
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"formRows"];
}

#pragma mark - add form row

- (void)addFormRow:(JTRowDescriptor *)row
{
    if ([row jt_isNotEmpty]) {
        [self insertFormRow:row inAllRowsAtIndex:self.allRows.count];
        [self insertFormRow:row inFormRowsAtIndex:self.formRows.count];
        [self.formDescriptor addRowToTagCollection:row];
    }
}

- (void)addFormRow:(JTRowDescriptor *)row afterRow:(JTRowDescriptor *)afterRow
{
    if ([row jt_isNotEmpty] && [afterRow jt_isNotEmpty]) {
        [self insertFormRow:row inAllRowsAtIndex:[self.allRows indexOfObject:afterRow] + 1];
        [self insertFormRow:row inFormRowsAtIndex:[self.formRows indexOfObject:afterRow] + 1];
        [self.formDescriptor addRowToTagCollection:row];
    }
}

- (void)addFormRow:(JTRowDescriptor *)row beforeRow:(JTRowDescriptor *)beforeRow
{
    if ([row jt_isNotEmpty] && [beforeRow jt_isNotEmpty]) {
        [self insertFormRow:row inAllRowsAtIndex:[self.allRows indexOfObject:beforeRow] - 1];
        [self insertFormRow:row inFormRowsAtIndex:[self.formRows indexOfObject:beforeRow] - 1];
        [self.formDescriptor addRowToTagCollection:row];
    }
}

#pragma mark - remove form row

- (void)removeFormRow:(JTRowDescriptor *)row
{
    if ([row jt_isNotEmpty]) {
        [self removeRowInAllRows:row];
        [self removeRowInFormRows:row];
        [self.formDescriptor removeRowFromTagCollection:row];
    }
}

- (void)removeFormRowWithTag:(NSString *)tag
{
    JTRowDescriptor *row = [self.formDescriptor findRowByTag:tag];
    [self removeFormRow:row];
}

- (void)removeFormRowAtIndex:(NSUInteger)index
{
    if (index >= 0 && index < self.formRows.count) {
        JTRowDescriptor *row = [self.formRows objectAtIndex:index];
        [self removeFormRow:row];
    }
}

- (void)moveRowAtIndexPath:(NSIndexPath *)sourceIndex toIndexPath:(NSIndexPath *)destinationIndex{}

#pragma mark - all rows

- (void)insertFormRow:(JTRowDescriptor *)row inAllRowsAtIndex:(NSUInteger)index
{
    if (index == NSNotFound) {
        index = self.allRows.count;
    }
    if (index < 0) {
        index = 0;
    }
    if ([self.allRows indexOfObject:row] == NSNotFound) {
        [self.allRows insertObject:row atIndex:index];
    }
}

- (void)removeRowInAllRows:(JTRowDescriptor *)row
{
    [self.allRows removeObject:row];
}

- (void)removeRowInAllRowsByIndex:(NSUInteger)index
{
    // fixme 锁
    if (index >= 0 && index < self.allRows.count) {
        [self.allRows removeObjectAtIndex:index];
    }
}

#pragma mark - form rows

- (void)insertFormRow:(JTRowDescriptor *)row inFormRowsAtIndex:(NSUInteger)index
{
    if (index == NSNotFound) {
        index = self.formRows.count;
    }
    if (index < 0) {
        index = 0;
    }
    if (!row.hidden) {
        if ([self.formRows indexOfObject:row] == NSNotFound) {
            // fixme
            [self.formRows insertObject:row atIndex:index];
        }
    }
}

- (void)removeRowInFormRows:(JTRowDescriptor *)row
{
    [self.formRows removeObject:row];
}

- (void)removeRoeInFormRowsByIndex:(NSUInteger)index
{
    // fixme 锁
    if (index >= 0 && index < self.formRows.count) {
        [self.formRows removeObjectAtIndex:index];
    }
}

@end
