//
//  JTFormDescriptor.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTFormDescriptor.h"
#import "JTSectionDescriptor.h"
#import "JTRowDescriptor.h"
#import "JTBaseCell.h"
#import "JTForm.h"

@interface JTFormDescriptor ()
@property (nonatomic, strong, readwrite) NSMutableArray *formSections;
@property (nonatomic, strong, readwrite) NSMutableArray *allSections;
@end

@implementation JTFormDescriptor

@synthesize disabled = _disabled;

- (instancetype)init
{
    if (self = [super init]) {
        _formSections                   = @[].mutableCopy;
        _allSections                    = @[].mutableCopy;
        _allRowsByTag                   = @{}.mutableCopy;
        _addAsteriskToRequiredRowsTitle = false;
        _noValueShowText                = false;
        
        [self addObserver:self forKeyPath:@"formSections" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

+ (nonnull instancetype)formDescriptor
{
    return [[JTFormDescriptor alloc] init];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (!self.delegate) return;
    
    if ([keyPath isEqualToString:@"formSections"]) {
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeInsertion)])
        {
            NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            [self.delegate formSectionsHaveBeenAddedAtIndexes:indexSet];
        }
        else if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeRemoval)])
        {
            NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            [self.delegate formSectionsHaveBeenRemovedAtIndexes:indexSet];
        }
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"formSections"];
}

#pragma mark - add section

- (void)addSection:(JTSectionDescriptor *)section atIndex:(NSUInteger)index
{
    if (!section || index > _allSections.count) return;
    
    BOOL result = [self _insertFormSection:section inAllSectionsAtIndex:index];
    if (result) [self evaluateFormSectionIsHidden:section];
}

- (void)addSection:(JTSectionDescriptor *)section
{
    [self addSection:section atIndex:_allSections.count];
}

- (void)addSection:(JTSectionDescriptor *)section afterSection:(JTSectionDescriptor *)afterSection
{
    if (![_allSections containsObject:section]) {
        NSUInteger afterIndex = [self.allSections indexOfObject:afterSection];
        [self addSection:section atIndex:afterIndex==NSNotFound ? _allSections.count : afterIndex + 1];
    }
}

- (void)addSection:(JTSectionDescriptor *)section beforeSection:(JTSectionDescriptor *)beforeSection
{
    if (![_allSections containsObject:section]) {
        NSUInteger beforeIndex = [self.allSections indexOfObject:beforeSection];
        [self addSection:section atIndex:beforeIndex==NSNotFound ? _allSections.count : beforeIndex];
    }
}

#pragma mark - remove section

- (void)removeSection:(JTSectionDescriptor *)section
{
    [self hideFormSection:section];
    [self _removeSectionsInAllSections:@[section]];
}

- (void)removeSectionAtIndex:(NSUInteger)index
{
    [self removeSectionsAtIndexes:[NSIndexSet indexSetWithIndex:index]];
}

- (void)removeSectionsAtIndexes:(NSIndexSet *)indexes
{
    [self hideFormSectionsAtIndexes:indexes];
    NSArray *sections = [self.allSections objectsAtIndexes:indexes];
    [self _removeSectionsInAllSections:sections];
}

#pragma mark - hidden or show section

- (void)evaluateFormSectionIsHidden:(JTSectionDescriptor *)section
{
    if (section.hidden) {
        [self hideFormSection:section];
    } else {
        [self showFormSection:section];
    }
}

- (void)showFormSection:(JTSectionDescriptor *)section
{
    if ([self.formSections containsObject:section]) return;
    if (![self.allSections containsObject:section]) return;

    NSUInteger indexInForm = NSNotFound;
    NSUInteger indexInAll = [self.allSections indexOfObject:section];
    if (indexInAll != NSNotFound) {
        while (indexInForm == NSNotFound && indexInAll > 0) {
            JTSectionDescriptor *previousSection = [self.allSections objectAtIndex:--indexInAll];
            indexInForm = [self.formSections indexOfObject:previousSection];
        }
        [self _insertFormSection:section inFormSectionsAtIndex:indexInForm == NSNotFound ? 0 : ++indexInForm];
    }
}

- (void)hideFormSection:(JTSectionDescriptor *)section
{
    [[(JTForm *)self.delegate tableView] endEditing:YES];

    [self _removeFormSectionInFormSections:section];
}

- (void)hideFormSectionsAtIndexes:(NSIndexSet *)indexes
{
    // fixme 同上，需要优化
    if ([[(JTForm *)self.delegate tableView] isEditing]) {
        [[(JTForm *)self.delegate tableView] endEditing:YES];
    }
    NSArray *sections = [self.allSections objectsAtIndexes:indexes];
    for (JTSectionDescriptor *section in sections) {
        [self _removeFormSectionInFormSections:section];
    }
}

#pragma mark - section

- (JTSectionDescriptor *)sectionAtIndex:(NSUInteger)index
{
    if (index < 0 || index >= self.formSections.count) return nil;
    return self.formSections[index];
}

#pragma mark - all sections

- (BOOL)_insertFormSection:(JTSectionDescriptor *)section inAllSectionsAtIndex:(NSUInteger)index
{
    if (index > _allSections.count) index = _allSections.count;
    if (index < 0)                  index = 0;
    
    if (![self.allSections containsObject:section]) {
        section.formDescriptor = self;
        [self.allSections insertObject:section atIndex:index];
        
        // 在这里为什么使用 allRows 而不是 formRows 属性呢？
        // 因为单元行在某些情况下可能会被隐藏掉，那么为了获取到该行的值，就必须使用 allRows 属性。
        [section.allRows enumerateObjectsUsingBlock:^(JTRowDescriptor *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addRowToTagCollection:obj];
        }];
        return true;
    }
    return false;
}

- (void)_removeSectionsInAllSections:(NSArray<JTSectionDescriptor *> *)sections
{
    for (JTSectionDescriptor *section in sections) {
        if ([_allSections containsObject:section]) {
            [section.allRows enumerateObjectsUsingBlock:^(JTRowDescriptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self removeRowFromTagCollection:obj];
            }];
            section.formDescriptor = nil;
            [_allSections removeObject:section];
        }
    }
}

#pragma mark - form sections

- (void)_insertFormSection:(JTSectionDescriptor *)section inFormSectionsAtIndex:(NSUInteger)index
{
    if (section.hidden) return;
    if (index > _formSections.count) index = self.formSections.count;
    if (index < 0)                   index = 0;
    
    if (![self.formSections containsObject:section]) {
        [[self mutableArrayValueForKey:@"formSections"] insertObject:section atIndex:index];
    }
}

- (void)_removeFormSectionInFormSections:(JTSectionDescriptor *)section
{
    [[self mutableArrayValueForKey:@"formSections"] removeObject:section];
}

#pragma mark - tag collection

- (void)addRowToTagCollection:(JTRowDescriptor *)row
{
    if (row.tag) [_allRowsByTag setObject:row forKey:row.tag];
}

- (void)removeRowFromTagCollection:(JTRowDescriptor *)row
{
    if (row.tag) [_allRowsByTag removeObjectForKey:row.tag];
}

- (JTRowDescriptor *)formRowWithTag:(id<NSCopying>)tag
{
    if (tag) return self.allRowsByTag[tag];
    return nil;
}

#pragma mark - row

//- (JTRowDescriptor *)nextRowDescriptorForRow:(JTRowDescriptor *)currentRow
//{
//    NSUInteger indexOfRow = [currentRow.sectionDescriptor.formRows indexOfObject:currentRow];
//    if (indexOfRow != NSNotFound) {
//        if ((indexOfRow+1) < currentRow.sectionDescriptor.formRows.count) {
//            return [currentRow.sectionDescriptor.formRows objectAtIndex:indexOfRow+1];
//        } else {
//            NSUInteger sectionIndex = [self.formSections indexOfObject:currentRow.sectionDescriptor];
//            if (sectionIndex != NSNotFound && (sectionIndex + 1) < self.formSections.count) {
//                JTSectionDescriptor *nextSection = self.formSections[++sectionIndex];
//                while (nextSection.formRows.count == 0 && (sectionIndex + 1) < self.formSections.count) {
//                    nextSection = [self.formSections objectAtIndex:++sectionIndex];
//                }
//                return nextSection.formRows.firstObject;
//            }
//        }
//    }
//    return nil;
//}

//- (JTRowDescriptor *)previousRowDescriptorForRow:(JTRowDescriptor *)currentRow
//{
//    NSUInteger indexOfRow = [currentRow.sectionDescriptor.formRows indexOfObject:currentRow];
//    if (indexOfRow != NSNotFound) {
//        if (indexOfRow > 0) {
//            return [currentRow.sectionDescriptor.formRows objectAtIndex:indexOfRow - 1];
//        } else {
//            NSUInteger sectionIndex = [self.formSections indexOfObject:currentRow.sectionDescriptor];
//            if (sectionIndex != NSNotFound && sectionIndex > 0) {
//                JTSectionDescriptor *previousSection = [self.formSections objectAtIndex:--sectionIndex];
//                while (previousSection.formRows.count == 0 && sectionIndex > 0) {
//                    previousSection = [self.formSections objectAtIndex:--sectionIndex];
//                }
//                return previousSection.formRows.lastObject;
//            }
//        }
//    }
//    return nil;
//}

- (NSIndexPath *)indexPathForRowDescriptor:(JTRowDescriptor *)rowDescriptor
{
    JTSectionDescriptor *section = rowDescriptor.sectionDescriptor;
    if (section) {
        NSUInteger sectionIndex = [self.formSections indexOfObject:section];
        if (sectionIndex != NSNotFound) {
            NSUInteger rowIndex = [section.formRows indexOfObject:rowDescriptor];
            if (rowIndex != NSNotFound) {
                return [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
            }
        }
    }
    return nil;
}

- (JTRowDescriptor *)rowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.formSections.count > indexPath.section &&
        [self.formSections[indexPath.section] formRows].count > indexPath.row)
    {
        return [self.formSections[indexPath.section] formRows][indexPath.row];
    }
    return nil;
}

#pragma mark - disabled

- (void)setDisabled:(BOOL)disabled
{
    if (disabled != _disabled) {
        _disabled = disabled;
        if (!self.delegate) return;
        
        [[(JTForm *)self.delegate tableView] endEditing:YES];
        
        for (JTSectionDescriptor *section in self.formSections) {
            for (JTRowDescriptor *row in section.formRows) {
                [row updateUI];
            }
        }
    }
}

@end
