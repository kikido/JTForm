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
#import "JTCollectionLayoutInfo.h"

@interface JTFormDescriptor ()
@property (nonatomic, strong, readwrite) NSMutableArray *formSections;
@property (nonatomic, strong, readwrite) NSMutableArray *allSections;
@property (nonatomic, weak  ) JTCollectionLayoutInfo *collectionInfo;
@property (nonatomic, strong) NSLock *allLock;
@property (nonatomic, strong) NSLock *formLock;
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
        _allLock                        = [[NSLock alloc] init];
        _formLock                       = [[NSLock alloc] init];
        
        // collection
        _numberOfColumn  = 0;
        _itmeSize        = CGSizeZero;
        _lineSpace       = 0.;
        _interItemSpace  = 0.;
        _sectionInsets   = UIEdgeInsetsZero;
        _scrollDirection = JTFormScrollDirectionVertical;
        
        [self addObserver:self forKeyPath:@"formSections" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

+ (nonnull instancetype)formDescriptor
{
    return [[JTFormDescriptor alloc] init];
}

#pragma mark - setter

- (void)setNumberOfColumn:(NSUInteger)numberOfColumn
{
    _numberOfColumn = numberOfColumn;
    _collectionInfo.numberOfColumn = numberOfColumn;
}

- (void)setItmeSize:(CGSize)itmeSize
{
    _itmeSize = itmeSize;
    _collectionInfo.itemSize = itmeSize;
}

- (void)setLineSpace:(CGFloat)lineSpace
{
    _lineSpace = lineSpace;
    _collectionInfo.lineSpace = lineSpace;
}

- (void)setInterItemSpace:(CGFloat)interItemSpace
{
    _interItemSpace = interItemSpace;
    _collectionInfo.interItemSpace = interItemSpace;
}

- (void)setSectionInsets:(UIEdgeInsets)sectionInsets
{
    _sectionInsets = sectionInsets;
    _collectionInfo.sectionInsets = sectionInsets;
}

- (void)setScrollDirection:(JTFormScrollDirection)scrollDirection
{
    _scrollDirection = scrollDirection;
    _collectionInfo.scrollDirection = scrollDirection;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (!self.form) return;
    
    if ([keyPath isEqualToString:@"formSections"]) {
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeInsertion)]) { // insert
            NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            [self.form formSectionsHaveBeenAddedAtIndexes:indexSet];
        }
        else if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeRemoval)]) { // remove
            NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            [self.form formSectionsHaveBeenRemovedAtIndexes:indexSet];
        }
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"formSections"];
}

#pragma mark - add section

- (void)addSection:(JTSectionDescriptor *)section
{
    [self addSections:@[section] atIndex:_allSections.count];
}

- (void)addSections:(NSArray<JTSectionDescriptor *> *)sections
{
    [self addSections:sections atIndex:_allSections.count];
}

- (void)addSections:(NSArray<JTSectionDescriptor *> *)sections beforeSection:(JTSectionDescriptor *)beforeSection
{
    NSUInteger index = [self indexOfSection:beforeSection];
    if (index != NSNotFound) {
        [self addSections:sections atIndex:index];
    }
}

- (void)addSections:(NSArray<JTSectionDescriptor *> *)sections afterSection:(JTSectionDescriptor *)afterSection
{
    NSUInteger index = [self indexOfSection:afterSection];
    if (index != NSNotFound) {
        [self addSections:sections atIndex:index + 1];
    }
}

- (void)addSections:(NSArray<JTSectionDescriptor *> *)sections atIndex:(NSUInteger)index
{
    if (!sections || sections.count == 0) {
        return;
    }
    [self _insertSectionsIntoAllSections:sections atIndex:index];

    __block NSUInteger indexOfStart = NSNotFound;
    [sections enumerateObjectsUsingBlock:^(JTSectionDescriptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.hidden == false) {
            indexOfStart = [self indexOfSectionAtFormSectionsBeforeInsert:obj];
            *stop = true;
        }
    }];
    NSArray<JTSectionDescriptor *> *insertSections = [sections objectsAtIndexes:[sections indexesOfObjectsPassingTest:^BOOL(JTSectionDescriptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return !obj.hidden;
    }]];
    if (insertSections.count > 0) {
        [self _insertSectionsIntoFormSections:insertSections atIndex:indexOfStart];
    }
}

#pragma mark - remove section

- (void)removeSection:(JTSectionDescriptor *)section
{
    [self removeSections:@[section]];
}

- (void)removeSections:(NSArray<JTSectionDescriptor *> *)sections
{
    [self _removeSectionsFromAllSections:sections];
    __block BOOL existed = false;
    [sections enumerateObjectsUsingBlock:^(JTSectionDescriptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.formRows enumerateObjectsUsingBlock:^(JTRowDescriptor * _Nonnull row, NSUInteger idx, BOOL * _Nonnull rStop) {
            if ([row isCellExist] && [row.cellForDescriptor jt_isFirstResponder] ) {
                [row.cellForDescriptor resignFirstResponder];
                // FIXME: 是否存在第一响应者
                *rStop = true;
                existed = true;
            }
        }];
        if (existed) *stop = true;
    }];
    [self _removeSectionsFromFormSections:sections];
}

- (void)removeSectionAtIndex:(NSUInteger)index
{
    JTSectionDescriptor *section = [self sectionAtIndex:index];
    [self removeSection:section];
}

#pragma mark - hidden or show section

- (void)evaluateFormSectionIsHidden:(JTSectionDescriptor *)section
{
    if (!section) return;
    
    if (section.hidden) {
        [self hideFormSections:@[section]];
    } else {
        [self showFormSection:section];
    }
}

- (void)showFormSection:(JTSectionDescriptor *)section
{
    [self.formLock lock];
    NSUInteger indexAtForm = [self.formSections indexOfObject:section];
    [self.formLock unlock];
    
    if (indexAtForm == NSNotFound) {
        indexAtForm = [self indexOfSectionAtFormSectionsBeforeInsert:section];
        [self _insertSectionsIntoFormSections:@[section] atIndex:indexAtForm];
    }
}

- (void)hideFormSections:(NSArray<JTSectionDescriptor *> *)sections
{
    for (JTSectionDescriptor *section in sections) {
        __block BOOL existed = false;
        [section.formRows enumerateObjectsUsingBlock:^(JTRowDescriptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.cellForDescriptor jt_isFirstResponder]) {
                [[obj cellForDescriptor] resignFirstResponder];
                *stop = true;
                existed = true;
            }
        }];
        if (existed) break;
    }
    [self _removeSectionsFromFormSections:sections];
}

#pragma mark - section

- (JTSectionDescriptor *)sectionAtIndex:(NSUInteger)index
{
    [self.allLock lock];
    JTSectionDescriptor *section = self.allSections[index];
    [self.allLock unlock];
    
    return section;
}

- (NSArray<JTSectionDescriptor *> *)sectionsAtIndexes:(NSIndexSet *)indexSet
{
    [self.allLock lock];
    NSArray *array = [self.allSections objectsAtIndexes:indexSet];
    [self.allLock unlock];
    
    return array;
}

- (NSUInteger)indexOfSection:(JTSectionDescriptor *)sectionDescriptor
{
    [self.allLock lock];
    NSUInteger index = [self.allSections indexOfObject:sectionDescriptor];
    [self.allLock unlock];
    
    return index;
}

#pragma mark - all sections

- (void)_insertSectionsIntoAllSections:(NSArray<JTSectionDescriptor *> *)sections atIndex:(NSUInteger)index
{
    [sections enumerateObjectsUsingBlock:^(JTSectionDescriptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert(![self.allSections containsObject:obj], @"section:%@ already in form, index:%tu", obj, idx);
        obj.formDescriptor = self;
        [obj.allRows enumerateObjectsUsingBlock:^(JTRowDescriptor * _Nonnull row, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addRowToTagCollection:row];
        }];
    }];
    [self.allLock lock];
    [self.allSections insertObjects:sections atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, sections.count)]];
    [self.allLock unlock];
}

- (void)_removeSectionsFromAllSections:(NSArray<JTSectionDescriptor *> *)sections
{
    [sections enumerateObjectsUsingBlock:^(JTSectionDescriptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.formDescriptor = nil;
        [obj.allRows enumerateObjectsUsingBlock:^(JTRowDescriptor * _Nonnull row, NSUInteger idx, BOOL * _Nonnull stop) {
            [self removeRowFromTagCollection:row];
        }];
    }];
    [self.allLock lock];
    [self.allSections removeObjectsInArray:sections];
    [self.allLock unlock];
}

#pragma mark - form sections

- (NSMutableArray<JTSectionDescriptor *> *)formSectionsArray
{
    return [self mutableArrayValueForKey:@"formSections"];
}

- (void)_insertSectionsIntoFormSections:(NSArray<JTSectionDescriptor *> *)sections atIndex:(NSUInteger)index
{
    [self.formLock lock];
    [[self formSectionsArray] insertObjects:sections atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, sections.count)]];
    [self.formLock unlock];
}

- (void)_removeSectionFromFormSections:(JTSectionDescriptor *)section
{
    [self.formLock lock];
    [[self formSectionsArray] removeObject:section];
    [self.formLock unlock];
}

- (void)_removeSectionsFromFormSections:(NSArray<JTSectionDescriptor *> *)sections
{
    [self.formLock lock];
    // FIXME: measure this step, 因为前面加锁了
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [sections enumerateObjectsUsingBlock:^(JTSectionDescriptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger index = [self.formSections indexOfObject:obj];
        if (index != NSNotFound) {
            [indexSet addIndex:index];
        }
    }];
    [[self formSectionsArray] removeObjectsAtIndexes:indexSet];
    [self.formLock unlock];
}

/** 在插入前，查找在 form rows 中插入的位置*/
- (NSUInteger)indexOfSectionAtFormSectionsBeforeInsert:(JTSectionDescriptor *)section
{
    [self.allLock lock];
    NSInteger indexAtAll  = [self.allSections indexOfObject:section];
    [self.allLock unlock];
    
    [self.formLock lock];
    NSUInteger indexAtForm = [self.formSections indexOfObject:section];
    [self.formLock unlock];
    
    if (indexAtForm == NSNotFound && indexAtAll != NSNotFound) {
        while (indexAtForm == NSNotFound && indexAtAll > 0) {
            [self.allLock lock];
            JTSectionDescriptor *previousSection = [self.allSections objectAtIndex:--indexAtAll];
            [self.allLock unlock];
            
            [self.formLock lock];
            indexAtForm = [self.formSections indexOfObject:previousSection];
            [self.formLock unlock];
        }
    }
    return indexAtForm == NSNotFound ? 0 : ++indexAtForm;
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
        NSUInteger sectionIndex = [self indexOfSection:section];
        if (sectionIndex != NSNotFound) {
            NSUInteger rowIndex = [section indexOfRow:rowDescriptor];
            if (rowIndex != NSNotFound) {
                return [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
            }
        }
    }
    return nil;
}

- (JTRowDescriptor *)rowAtIndexPath:(NSIndexPath *)indexPath
{
    JTSectionDescriptor *section = [self sectionAtIndex:indexPath.section];
    JTRowDescriptor *row = [section rowAtIndex:indexPath.row];
    return row;
}

#pragma mark - disabled

- (void)setDisabled:(BOOL)disabled
{
    if (disabled != _disabled) {
        _disabled = disabled;
        if (!self.form) return;
                
        __block BOOL existed = false;
        [self.formSections enumerateObjectsUsingBlock:^(JTSectionDescriptor * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
            [section.formRows enumerateObjectsUsingBlock:^(JTRowDescriptor * _Nonnull row, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!existed && [row.cellForDescriptor jt_isFirstResponder]) {
                    existed = true;
                    [[row cellForDescriptor] resignFirstResponder];
                }
                [row updateCell];
            }];
        }];
    }
}

@end
