//
//  JTFormDescriptor.m
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTFormDescriptor.h"
#import "JTForm.h"

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
    if ([keyPath isEqualToString:@"formSections"]) {
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeInsertion)])
        {
            NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            JTSectionDescriptor *section = [self.formSections objectAtIndex:indexSet.firstIndex];
            [self.delegate formSectionHasBeenAdded:section atIndex:indexSet.firstIndex];
        }
        else if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeRemoval)])
        {
            NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            JTSectionDescriptor *section = change[NSKeyValueChangeOldKey][0];
            [self.delegate formSectionHasBeenRemoved:section atIndex:indexSet.firstIndex];
        }
    }
    
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"formSections"];
}

#pragma mark - section

- (void)addFormSection:(JTSectionDescriptor *)section
{
    [self insertFormSection:section inAllSectionsAtIndex:self.allSections.count];
    [self insertFormSection:section inAllSectionsAtIndex:self.formSections.count];
}

- (void)addFormSection:(JTSectionDescriptor *)section atIndex:(NSInteger)index
{
    
}

- (void)addFormSection:(JTSectionDescriptor *)section afterSection:(JTSectionDescriptor *)afterSection
{
    
}

- (void)addFormSection:(JTSectionDescriptor *)section beforeSection:(JTSectionDescriptor *)beforeSection
{
    
}

- (void)evaluateFormSectionIsHidden:(JTSectionDescriptor *)section
{
    if (section.hidden) {
        JTBaseCell *cell = (JTBaseCell *)[((JTForm *)self.delegate).tableNode findFirstResponder];
        if ([cell isKindOfClass:[JTBaseCell class]]) {
            [cell resignFirstResponder];
        }
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
    [self removeFormSectionInFormSections:section];
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
            [self.formSections insertObject:section atIndex:index];
        }
    }
}

- (void)removeFormSectionInFormSections:(JTSectionDescriptor *)section
{
    [self.formSections removeObject:section];
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
@end
