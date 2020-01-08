//
//  JTCollectionLayoutInfo.m
//  JTFormDemo
//
//  Created by dqh on 2019/12/18.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTCollectionLayoutInfo.h"

#import <AsyncDisplayKit/ASHashing.h>

@implementation JTCollectionLayoutInfo

- (instancetype)initWithNumberOfColumn:(NSInteger)numberOfColumn
                         headerHeights:(NSArray *)headerHeights
                         footerHeights:(NSArray *)footerHeights
                           columnSpace:(CGFloat)interItemSpace
                             lineSpace:(CGFloat)lineSpace
                              itemSize:(CGSize)itemSize
                         sectionInsets:(UIEdgeInsets)sectionInsets
                                  type:(JTFormType)formType
                       scrollDirection:(JTFormScrollDirection)scrollDirection;

{
    if (self = [super init]) {
        _headerHeights = headerHeights;
        _footerHeights = footerHeights;
        _numberOfColumn = numberOfColumn;
        _interItemSpace = interItemSpace;
        _lineSpace = lineSpace;
        _itemSize = itemSize;
        _sectionInsets = sectionInsets;
        _formType = formType;
        _scrollDirection = scrollDirection;
    }
    return self;
}

- (BOOL)isEqualToInfo:(JTCollectionLayoutInfo *)info
{
    if (info == nil) {
        return NO;
    }
    return _numberOfColumn == info.numberOfColumn
    && _interItemSpace == info.interItemSpace
    && _lineSpace == info.lineSpace
    && CGSizeEqualToSize(_itemSize, info.itemSize)
    && UIEdgeInsetsEqualToEdgeInsets(_sectionInsets, info.sectionInsets)
    && _formType == info.formType
    && _scrollDirection == info.scrollDirection
    && jtNumberArrayEqual(_headerHeights, info.headerHeights)
    && jtNumberArrayEqual(_footerHeights, info.footerHeights);
}

static inline bool jtNumberArrayEqual(NSArray *array, NSArray *bArray) {
    if (array.count != bArray.count) {
        return false;
    }
    for (NSInteger i = array.count - 1; i < 0; i--) {
        if (fabsf([array[i] floatValue] - [bArray[i] floatValue]) > 0.00001) {
            return false;
        }
    }
    return true;
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
      return YES;
    }
    if (![object isKindOfClass:[JTCollectionLayoutInfo class]]) {
      return NO;
    }
    return [self isEqualToInfo:object];
}

- (NSUInteger)hash
{
    struct {
        NSArray *headerHeight;
        NSArray *footerHeight;
        NSInteger numberOfColumn;
        CGFloat interItemSpace;
        CGFloat lineSpace;
        CGSize itemSize;
        UIEdgeInsets sectionInsets;
        JTFormType formType;
        JTFormScrollDirection scrollDirection;
    } data = {
        _headerHeights,
        _footerHeights,
        _numberOfColumn,
        _interItemSpace,
        _lineSpace,
        _itemSize,
        _sectionInsets,
        _formType,
        _scrollDirection
    };
    return ASHashBytes(&data, sizeof(data));
}

@end
