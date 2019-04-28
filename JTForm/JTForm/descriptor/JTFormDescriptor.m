//
//  JTFormDescriptor.m
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTFormDescriptor.h"
#import "JTBaseCell.h"
#import "JTDefaultCell.h"
#import "JTFormTextFieldCell.h"

@interface JTFormDescriptor ()
@property (nonatomic, strong, readwrite) NSMutableArray *formSections;
@property (nonatomic, strong, readwrite) NSMutableArray *allSections;
@end

@implementation JTFormDescriptor

- (instancetype)init
{
    if (self = [super init]) {
        _formSections = @[].mutableCopy;
        _allSections = @[].mutableCopy;
        _allRowsByTag = @{}.mutableCopy;
        
        _addAsteriskToRequiredRowsTitle = false;
        
        [self addObserver:self forKeyPath:@"formSections" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)  context:nil];
    }
    return self;
}

+ (nonnull instancetype)formDescriptor
{
    return [[[self class] alloc] init];
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (!self.delegate) {
        return;
    }
    NSLog(@"dddddddd-dddddddd-dddddddd");
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

- (void)addFormSection:(JTSectionDescriptor *)section
{
    [self insertFormSection:section inAllSectionsAtIndex:self.allSections.count];
    [self evaluateFormSectionIsHidden:section];
}

- (void)addFormSection:(JTSectionDescriptor *)section atIndex:(NSInteger)index
{
    [self insertFormSection:section inAllSectionsAtIndex:index];
    [self evaluateFormSectionIsHidden:section];
}

- (void)addFormSection:(JTSectionDescriptor *)section afterSection:(JTSectionDescriptor *)afterSection
{
    NSUInteger index = [self.allSections indexOfObject:section];
    NSUInteger afterIndex = [self.allSections indexOfObject:afterSection];;
    
    if (index == NSNotFound) {
        if (afterIndex != NSNotFound) {
            [self addFormSection:section atIndex:afterIndex + 1];
        } else {
            [self addFormSection:section];
        }
    }
}

- (void)addFormSection:(JTSectionDescriptor *)section beforeSection:(JTSectionDescriptor *)beforeSection
{
    NSUInteger index = [self.allSections indexOfObject:section];
    NSUInteger beforeIndex = [self.allSections indexOfObject:beforeSection];;
    
    if (index == NSNotFound) {
        if (beforeIndex != NSNotFound) {
            [self addFormSection:section atIndex:beforeIndex - 1];
        } else {
            [self addFormSection:section];
        }
    }
}

#pragma mark - remove section

- (void)removeFormSection:(JTSectionDescriptor *)section
{
    [self hideFormSection:section];
    [self removeFormSectionInAllSections:section];
}

- (void)removeFormSectionAtIndex:(NSUInteger)index
{
    [self hideFormSectionsAtIndexes:[NSIndexSet indexSetWithIndex:index]];
    [self.allSections removeObjectAtIndex:index];
}

- (void)removeFormSectionsAtIndexes:(NSIndexSet *)indexes
{
    [self hideFormSectionsAtIndexes:indexes];
    [self.allSections removeObjectsAtIndexes:indexes];
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
    NSUInteger formIndex = [self.formSections indexOfObject:section];
    if (formIndex != NSNotFound) {
        return;
    }
    NSUInteger index = [self.allSections indexOfObject:section];
    if (index != NSNotFound) {
        while (formIndex == NSNotFound && index > 0) {
            JTSectionDescriptor *previousSection = [self.allSections objectAtIndex:--index];
            formIndex = [self.formSections indexOfObject:previousSection];
        }
        [self insertFormSection:section inFormSectionsAtIndex:formIndex == NSNotFound ? 0 : ++formIndex];
    }
}

- (void)hideFormSection:(JTSectionDescriptor *)section
{
    JTBaseCell *cell = (JTBaseCell *)[((JTForm *)self.delegate).tableNode findFirstResponder];
    if ([cell isKindOfClass:[JTBaseCell class]]) {
        [cell resignFirstResponder];
    }
    [self removeFormSectionInFormSections:section];
}

- (void)hideFormSectionsAtIndexes:(NSIndexSet *)indexes
{
    JTBaseCell *cell = (JTBaseCell *)[((JTForm *)self.delegate).tableNode findFirstResponder];
    if ([cell isKindOfClass:[JTBaseCell class]]) {
        [cell resignFirstResponder];
    }
    NSArray *sections = [self.allSections objectsAtIndexes:indexes];
    for (JTSectionDescriptor *section in sections) {
        [self removeFormSectionInFormSections:section];
    }
}

#pragma mark - all sections

- (void)insertFormSection:(JTSectionDescriptor *)section inAllSectionsAtIndex:(NSUInteger)index
{
    if (index == NSNotFound) {
        index = self.allSections.count;
    }
    if (index < 0) {
        index = 0;
    }
    if ([self.allSections indexOfObject:section] == NSNotFound) {
        section.formDescriptor = self;
        [self.allSections insertObject:section atIndex:index];
        
        // 在这里为什么使用‘allRows’而不是‘formRows’属性呢？因为考虑到表单行在某些情况下可能会被隐藏掉，那么为了获取到该行的值，就必须使用‘allRows’属性。
        [section.allRows enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            JTRowDescriptor *row = (JTRowDescriptor *)obj;
            [self addRowToTagCollection:row];
        }];
    }
}

- (void)removeFormSectionInAllSections:(JTSectionDescriptor *)section
{
    [self.allSections removeObject:section];
}


#pragma mark - form sections

- (void)insertFormSection:(JTSectionDescriptor *)section inFormSectionsAtIndex:(NSUInteger)index
{
    if (!section.hidden) {
        if (index == NSNotFound) {
            index = self.formSections.count;
        }
        if (index < 0) {
            index = 0;
        }
        if ([self.formSections indexOfObject:section] == NSNotFound) {
            [[self mutableArrayValueForKey:@"formSections"] insertObject:section atIndex:index];
        }
    }
}

- (void)removeFormSectionInFormSections:(JTSectionDescriptor *)section
{
    [[self mutableArrayValueForKey:@"formSections"] removeObject:section];
}


#pragma mark - tag collection

- (void)addRowToTagCollection:(JTRowDescriptor *)row
{
    if ([row.tag jt_isNotEmpty]) {
        self.allRowsByTag[row.tag] = row;
    }
}

- (void)removeRowFromTagCollection:(JTRowDescriptor *)row
{
    if ([row.tag jt_isNotEmpty]) {
        [self.allRowsByTag removeObjectForKey:row.tag];
    }
}

- (JTRowDescriptor *)formRowWithTag:(NSString *)tag
{
    if ([tag jt_isNotEmpty]) {
        return self.allRowsByTag[tag];
    } else {
        return nil;
    }
}

- (JTRowDescriptor *)formRowAtIndex:(NSIndexPath *)indexPath
{
    if (self.formSections.count > indexPath.section && [self.formSections[indexPath.section] formRows].count > indexPath.row) {
        return [self.formSections[indexPath.section] formRows][indexPath.row];
    }
    return nil;
}

#pragma mark - row

- (JTRowDescriptor *)nextRowDescriptorForRow:(JTRowDescriptor *)currentRow
{
    NSUInteger indexOfRow = [currentRow.sectionDescriptor.formRows indexOfObject:currentRow];
    if (indexOfRow != NSNotFound) {
        if ((indexOfRow+1) < currentRow.sectionDescriptor.formRows.count) {
            return [currentRow.sectionDescriptor.formRows objectAtIndex:indexOfRow+1];
        } else {
            NSUInteger sectionIndex = [self.formSections indexOfObject:currentRow.sectionDescriptor];
            if (sectionIndex != NSNotFound && (sectionIndex + 1) < self.formSections.count) {
                JTSectionDescriptor *nextSection = self.formSections[++sectionIndex];
                while (nextSection.formRows.count == 0 && (sectionIndex + 1) < self.formSections.count) {
                    nextSection = [self.formSections objectAtIndex:++sectionIndex];
                }
                return nextSection.formRows.firstObject;
            }
        }
    }
    return nil;
}

- (JTRowDescriptor *)previousRowDescriptorForRow:(JTRowDescriptor *)currentRow
{
    NSUInteger indexOfRow = [currentRow.sectionDescriptor.formRows indexOfObject:currentRow];
    if (indexOfRow != NSNotFound) {
        if (indexOfRow > 0) {
            return [currentRow.sectionDescriptor.formRows objectAtIndex:indexOfRow - 1];
        } else {
            NSUInteger sectionIndex = [self.formSections indexOfObject:currentRow.sectionDescriptor];
            if (sectionIndex != NSNotFound && sectionIndex > 0) {
                JTSectionDescriptor *previousSection = [self.formSections objectAtIndex:--sectionIndex];
                while (previousSection.formRows.count == 0 && sectionIndex > 0) {
                    previousSection = [self.formSections objectAtIndex:--sectionIndex];
                }
                return previousSection.formRows.lastObject;
            }
        }
    }
    return nil;
}

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

@end
