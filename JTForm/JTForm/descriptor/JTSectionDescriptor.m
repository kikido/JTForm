//
//  JTSectionDescriptor.m
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTSectionDescriptor.h"
#import "JTRowDescriptor.h"
#import "JTBaseCell.h"

CGFloat const JTFormDefaultSectionHeaderHeight = 25.;
CGFloat const JTFormDefaultSectionFooterHeight = 25.;

@interface JTSectionDescriptor ()
@property (nonatomic, strong, readwrite) NSMutableArray *formRows;
@property (nonatomic, strong, readwrite) NSMutableArray *allRows;
@end

@implementation JTSectionDescriptor

@synthesize hidden = _hidden;

- (instancetype)init
{
    if (self = [super init]) {
        _formRows = @[].mutableCopy;
        _allRows = @[].mutableCopy;
        _sectionOptions = JTFormSectionOptionNone;
        _headerHeight = JTFormDefaultSectionHeaderHeight;
        _footerHeight = JTFormDefaultSectionFooterHeight;
        
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
    // fixme 还没确认好时机
    if (!self.formDescriptor.delegate) {
        return;
    }
    NSLog(@"dddddddd-dddddddd-dddddddd");
    NSUInteger sectionIndex = [self.formDescriptor.formSections indexOfObject:object];
    NSMutableArray *tempArray = @[].mutableCopy;

    if ([keyPath isEqualToString:@"formRows"]) {
        if ([self.formDescriptor.formSections containsObject:self]) {            
            if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeInsertion)])
            {
                NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
                [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:sectionIndex];
                    [tempArray addObject:indexPath];
                }];
                [self.formDescriptor.delegate formRowsHaveBeenAddedAtIndexPaths:tempArray.copy];
            }
            else if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeRemoval)])
            {
                NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
                [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:sectionIndex];
                    [tempArray addObject:indexPath];
                }];
                [self.formDescriptor.delegate formRowsHaveBeenRemovedAtIndexPaths:tempArray.copy];
            }
        }
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"formRows"];
}

#pragma mark - add row

- (void)addFormRow:(JTRowDescriptor *)row
{
    [self insertFormRow:row inAllRowsAtIndex:self.allRows.count];
    [self evaluateFormRowIsHidden:row];
}


- (void)addFormRow:(JTRowDescriptor *)row atIndex:(NSInteger)index
{
    [self insertFormRow:row inAllRowsAtIndex:index];
    [self evaluateFormRowIsHidden:row];
}

- (void)addFormRow:(JTRowDescriptor *)row afterRow:(JTRowDescriptor *)afterRow
{
    NSUInteger index = [self.allRows indexOfObject:row];
    NSUInteger afterIndex = [self.allRows indexOfObject:afterRow];;
    
    if (index == NSNotFound) {
        if (afterIndex != NSNotFound) {
            [self addFormRow:row atIndex:afterIndex + 1];
        } else {
            [self addFormRow:row];
        }
    }
}

- (void)addFormRow:(JTRowDescriptor *)row beforeRow:(JTRowDescriptor *)beforeRow
{
    NSUInteger index = [self.allRows indexOfObject:row];
    NSUInteger beforeIndex = [self.allRows indexOfObject:row];;
    
    if (index == NSNotFound) {
        if (beforeIndex != NSNotFound) {
            [self addFormRow:row atIndex:beforeIndex - 1];
        } else {
            [self addFormRow:row];
        }
    }
}

#pragma mark - remove row

- (void)removeFormRow:(JTRowDescriptor *)row
{
    [self hideFormRow:row];
    [self removeFormRowInAllRows:row];
}

- (void)removeFormRowAtIndex:(NSUInteger)index
{
    [self hideFormRowsAtIndexes:[NSIndexSet indexSetWithIndex:index]];
    [self.allRows removeObjectAtIndex:index];
}

- (void)removeFormRowsAtIndexes:(NSIndexSet *)indexes
{
    [self hideFormRowsAtIndexes:indexes];
    [self.allRows removeObjectsAtIndexes:indexes];
}

- (void)removeFormRowWithTag:(NSString *)tag
{
    if ([tag jt_isNotEmpty]) {
        JTRowDescriptor *row = self.formDescriptor.allRowsByTag[tag];
        [self removeFormRow:row];
    }
}


- (void)moveRowAtIndexPath:(NSIndexPath *)sourceIndex toIndexPath:(NSIndexPath *)destinationIndex
{
    // fixme
}

#pragma mark - hidden or show row

- (void)evaluateFormRowIsHidden:(JTRowDescriptor *)row
{
    if (row.hidden) {
        [self hideFormRow:row];
    } else {
        [self showFormRow:row];
    }
}

- (void)showFormRow:(JTRowDescriptor *)row
{
    NSUInteger formIndex = [self.formRows indexOfObject:row];
    if (formIndex != NSNotFound) {
        return;
    }
    NSUInteger index = [self.allRows indexOfObject:row];
    if (index != NSNotFound) {
        while (formIndex == NSNotFound && index > 0) {
            JTRowDescriptor *previousRow = [self.allRows objectAtIndex:--index];
            formIndex = [self.formRows indexOfObject:previousRow];
        }
        [self insertFormRow:row inFormRowsAtIndex:formIndex == NSNotFound ? 0 : ++formIndex];
    }
}

- (void)hideFormRow:(JTRowDescriptor *)row
{
    JTBaseCell *cell = [row cellInForm];
    [cell resignFirstResponder];
    [self removeFormRowInFormRows:row];
}

- (void)hideFormRowsAtIndexes:(NSIndexSet *)indexes
{
    NSArray *rows = [self.allRows objectsAtIndexes:indexes];
    for (JTRowDescriptor *row in rows) {
        [self hideFormRow:row];
    }
}

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
        row.sectionDescriptor = self;
        [self.allRows insertObject:row atIndex:index];
        
        [self.formDescriptor addRowToTagCollection:row];
    }
}

- (void)removeFormRowInAllRows:(JTRowDescriptor *)row
{
    [self.allRows removeObject:row];
    [self.formDescriptor removeRowFromTagCollection:row];
}


#pragma mark - form rows

- (void)insertFormRow:(JTRowDescriptor *)row inFormRowsAtIndex:(NSUInteger)index
{
    if (!row.hidden) {
        if (index == NSNotFound) {
            index = self.formRows.count;
        }
        if (index < 0) {
            index = 0;
        }
        if ([self.formRows indexOfObject:row] == NSNotFound) {
            [[self mutableArrayValueForKey:@"formRows"] insertObject:row atIndex:index];
        }
    }
}

- (void)removeFormRowInFormRows:(JTRowDescriptor *)row
{
    [[self mutableArrayValueForKey:@"formRows"] removeObject:row];
}

#pragma mark - hidden

- (void)setHidden:(BOOL)hidden
{
    _hidden = hidden;
    [self.formDescriptor evaluateFormSectionIsHidden:self];
}

#pragma mark - disabled

//- (BOOL)disabled
//{
//    if (self.formDescriptor.disabled) {
//        return YES;
//    }
//    return self.disabled;
//}
#pragma mark - set

@end
