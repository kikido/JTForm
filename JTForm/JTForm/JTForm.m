//
//  JTForm.m
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTForm.h"
#import "JTBaseCell.h"

@interface JTForm () <ASTableDelegate, ASTableDataSource>
@property (nonatomic, strong) JTFormDescriptor *formDescriptor;
@end

@implementation JTForm

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"`-init` unavailable. Use `-formRowDescriptorWithTag:rowType:title:` instead" userInfo:nil];
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"`-initWithFrame:` unavailable. Use `-formRowDescriptorWithTag:rowType:title:` instead" userInfo:nil];
    return nil;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"`-initWithCoder:` unavailable. Use `-formRowDescriptorWithTag:rowType:title:` instead" userInfo:nil];
    return nil;
}


- (instancetype)initWithFormDescriptor:(JTFormDescriptor *)formDescriptor
{
    if (self = [super init]) {
        [self initializeForm];
    }
    return self;
}

- (void)initializeForm
{
    _tableNode            = [[ASTableNode alloc] init];
    _tableNode.dataSource = self;
    _tableNode.delegate   = self;
    [self addSubnode:_tableNode];
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
                                              JTFormRowTypeDefault : [JTDefaultCell class]
                                              }.mutableCopy;
    });
    return _cellClassesForRowDescriptorTypes;
}


@end
