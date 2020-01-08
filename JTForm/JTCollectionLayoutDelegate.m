//
//  JTCollectionLayoutDelegate.m
//  JTFormDemo
//
//  Created by dqh on 2019/12/18.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTCollectionLayoutDelegate.h"
#import "JTCollectionLayoutInfo.h"
#import <AsyncDisplayKit/ASCollectionElement.h>

@interface ASCellNode ()
@property (weak, nullable) ASCollectionElement *collectionElement;
@end

@implementation JTCollectionLayoutDelegate {
    JTCollectionLayoutInfo *_info;
}

- (instancetype)initWithInfo:(JTCollectionLayoutInfo *)info
{
    if (self = [super init]) {
        _info = info;
    }
    return self;
}

#pragma mark - ASCollectionLayoutDelegate

- (ASScrollDirection)scrollableDirections
{
    ASDisplayNodeAssertMainThread();
    if (_info.scrollDirection == JTFormScrollDirectionHorizontal) {
        return ASScrollDirectionHorizontalDirections;
    }
    return ASScrollDirectionVerticalDirections;
}

- (id)additionalInfoForLayoutWithElements:(ASElementMap *)elements
{
    ASDisplayNodeAssertMainThread();
    return _info;
}

+ (ASCollectionLayoutState *)calculateLayoutWithContext:(ASCollectionLayoutContext *)context
{
    ASElementMap *elements = context.elements;
    BOOL isDirectionVertical = ASScrollDirectionContainsVerticalDirection(context.scrollableDirections);
    CGFloat layoutWidth = isDirectionVertical ? context.viewportSize.width : context.viewportSize.height;

    JTCollectionLayoutInfo *info = ASDynamicCast(context.additionalInfo, JTCollectionLayoutInfo);
    if (!info) {
        return [[ASCollectionLayoutState alloc] initWithContext:context];
    }
    
    ASCollectionLayoutState *state;
    switch (info.formType) {
        case JTFormTypeCollectionColumnFlow:
        case JTFormTypeCollectionColumnFixed:
        {
            CGFloat top = 0.;
            NSMapTable<ASCollectionElement *, UICollectionViewLayoutAttributes *> *attrsMap = [NSMapTable elementToLayoutAttributesTable];
            NSMutableArray *columnHeights = @[].mutableCopy;

            NSInteger numberOfSection = [elements numberOfSections];
            for (NSUInteger section = 0; section < numberOfSection; section++) {
                NSInteger numberOfItems = [elements numberOfItemsInSection:section];
                if (isDirectionVertical == 0) {
                    top += info.sectionInsets.top;
                } else {
                    top += info.sectionInsets.left;
                }
                
                if ([info.headerHeights[section] floatValue] > 0) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
                    ASCollectionElement *element = [elements supplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
                    if (element) {
                        UICollectionViewLayoutAttributes *attrs =
                        [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                       withIndexPath:indexPath];
                        ASSizeRange sizeRange = [self _sizeRangeForHeaderOfSection:section
                                                                   withLayoutWidth:layoutWidth
                                                                            height:[info.headerHeights[section] floatValue]
                                                                              info:info
                                                               isDirectionVertical:isDirectionVertical];
                        CGSize size = [element.node layoutThatFits:sizeRange].size;
                        CGRect frame = isDirectionVertical ? CGRectMake(info.sectionInsets.left, top, size.width, size.height) :
                                                             CGRectMake(top, info.sectionInsets.top, size.width, size.height);
                        attrs.frame = frame;
                        [attrsMap setObject:attrs forKey:element];
                        top = isDirectionVertical ? CGRectGetMaxY(frame) : CGRectGetMaxX(frame);
                    }
                }

                [columnHeights addObject:[NSMutableArray array]];
                for (NSUInteger idx = 0; idx < info.numberOfColumn; idx++) {
                    [columnHeights[section] addObject:@(top)];
                }

                CGFloat columnWidth = isDirectionVertical ? [self _columnWidthForSection:section withLayoutWidth:layoutWidth info:info] :
                                                            [self _columnHeightForSection:section withLayoutWidth:layoutWidth info:info];
                for (NSUInteger idx = 0; idx < numberOfItems; idx++) {
                    NSUInteger columnIndex = [self _shortestColumnIndexInSection:section withColumnHeights:columnHeights];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
                    ASCollectionElement *element = [elements elementForItemAtIndexPath:indexPath];
                    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

                    CGSize size = CGSizeZero;
                    if (info.formType == JTFormTypeCollectionColumnFlow) {
                        ASSizeRange sizeRange = [self _sizeRangeForItem:element.node
                                                            atIndexPath:indexPath
                                                        withLayoutWidth:layoutWidth
                                                                   info:info
                                                    isDirectionVertical:isDirectionVertical];
                        size = [element.node layoutThatFits:sizeRange].size;
                    } else {
                        size = isDirectionVertical ? CGSizeMake(columnWidth, info.itemSize.height) : CGSizeMake(info.itemSize.width, columnWidth);
                    }
                    
                    CGPoint position = CGPointZero;
                    if (isDirectionVertical) {
                        position = CGPointMake(info.sectionInsets.left + (columnWidth + info.interItemSpace) * columnIndex,
                                               [columnHeights[section][columnIndex] floatValue]);
                    } else {
                        position = CGPointMake([columnHeights[section][columnIndex] floatValue],
                                               info.sectionInsets.top + (columnWidth + info.interItemSpace) * columnIndex);
                    }
                    CGRect frame = CGRectMake(position.x, position.y, size.width, size.height);
                    attr.frame = frame;
                    [attrsMap setObject:attr forKey:element];
                    columnHeights[section][columnIndex] = isDirectionVertical ? @(CGRectGetMaxY(frame) + info.lineSpace) : @(CGRectGetMaxX(frame) + info.lineSpace);
                }

                NSUInteger columnIndex = [self _tallestColumnIndexInSection:section withColumnHeights:columnHeights];
                top = isDirectionVertical ? [columnHeights[section][columnIndex] floatValue] - info.lineSpace + info.sectionInsets.bottom:
                                            [columnHeights[section][columnIndex] floatValue] - info.lineSpace + info.sectionInsets.right;
                if ([info.footerHeights[section] floatValue] > 0) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
                    ASCollectionElement *element = [elements supplementaryElementOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
                    if (element) {
                        top = isDirectionVertical ? top - info.sectionInsets.bottom : top - info.sectionInsets.right;
                        UICollectionViewLayoutAttributes *attrs =
                        [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                       withIndexPath:indexPath];
                        ASSizeRange sizeRange = [self _sizeRangeForHeaderOfSection:section
                                                                   withLayoutWidth:layoutWidth
                                                                            height:[info.footerHeights[section] floatValue]
                                                                              info:info
                                                               isDirectionVertical:isDirectionVertical];
                        CGSize size = [element.node layoutThatFits:sizeRange].size;
                        CGRect frame = isDirectionVertical ? CGRectMake(info.sectionInsets.left, top, size.width, size.height) :
                                                             CGRectMake(top, info.sectionInsets.top, size.width, size.height);
                        attrs.frame = frame;
                        [attrsMap setObject:attrs forKey:element];
                        top = isDirectionVertical ? CGRectGetMaxY(frame) + info.sectionInsets.bottom : CGRectGetMaxX(frame) + info.sectionInsets.right;
                    }
                }

                for (NSUInteger idx = 0; idx < [columnHeights[section] count]; idx++) {
                    columnHeights[section][idx] = @(top);
                }
            }

            CGFloat contentHeight = [[[columnHeights lastObject] firstObject] floatValue];
            CGSize contentSize = isDirectionVertical ? CGSizeMake(layoutWidth, contentHeight) : CGSizeMake(contentHeight, layoutWidth);
            state = [[ASCollectionLayoutState alloc] initWithContext:context
                                                         contentSize:contentSize
                                      elementToLayoutAttributesTable:attrsMap];
            break;
        }
        case JTFormTypeCollectionFixed: {
            // 跟前两种布局不同，这种布局在 header 和 itme 之间， item 和 footer 之间会有空隙。如果不想出现这种情况，
            // 那么需要重写下面的布局方式，可以将 header，同个section内所有的item，footer当做三个 stackSpec，然后再组合起来，比较麻烦就先这样了
            NSMutableArray<ASCellNode *> *children = [NSMutableArray array];
            NSInteger numberOfSection = [elements numberOfSections];

            for (NSUInteger section = 0; section < numberOfSection; section++) {
                NSInteger numberOfItems = [elements numberOfItemsInSection:section];
                if ([info.headerHeights[section] floatValue] > 0) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
                    ASCollectionElement *element = [elements supplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
                    if (element.node) {
                        CGFloat sectionWidth = isDirectionVertical ? [self _widthForSection:section withLayoutWidth:layoutWidth info:info] :
                                                                     [self _heightForSection:section withLayoutWidth:layoutWidth info:info];
                        element.node.style.preferredSize = isDirectionVertical ? CGSizeMake(sectionWidth, [info.headerHeights[section] floatValue]) :
                                                                                 CGSizeMake([info.headerHeights[section] floatValue], sectionWidth);
                        [children addObject:element.node];
                    }
                }
                for (NSUInteger idx = 0; idx < numberOfItems; idx++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
                    ASCollectionElement *element = [elements elementForItemAtIndexPath:indexPath];
                    element.node.style.preferredSize = info.itemSize;
                    [children addObject:element.node];
                }
                if ([info.footerHeights[section] floatValue] > 0) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
                    ASCollectionElement *element = [elements supplementaryElementOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
                    if (element.node) {
                        CGFloat sectionWidth = isDirectionVertical ? [self _widthForSection:section withLayoutWidth:layoutWidth info:info] :
                                                                     [self _heightForSection:section withLayoutWidth:layoutWidth info:info];
                        element.node.style.preferredSize = isDirectionVertical ? CGSizeMake(sectionWidth, [info.footerHeights[section] floatValue]) :
                                                                                 CGSizeMake([info.footerHeights[section] floatValue], sectionWidth);
                        [children addObject:element.node];
                    }
                }
            }
            ASStackLayoutDirection stackDirection = isDirectionVertical ? ASStackLayoutDirectionHorizontal : ASStackLayoutDirectionVertical;
            ASStackLayoutSpec *stackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:stackDirection
                                                                                   spacing:info.interItemSpace
                                                                            justifyContent:ASStackLayoutJustifyContentStart
                                                                                alignItems:ASStackLayoutAlignItemsStart
                                                                                  flexWrap:ASStackLayoutFlexWrapWrap
                                                                              alignContent:ASStackLayoutAlignContentStart
                                                                               lineSpacing:info.lineSpace
                                                                                  children:children];
            stackSpec.concurrent = YES;
            ASLayoutSpec *finalSpec = stackSpec;
            UIEdgeInsets sectionInset = info.sectionInsets;
            if (UIEdgeInsetsEqualToEdgeInsets(sectionInset, UIEdgeInsetsZero) == NO) {
              finalSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:sectionInset child:stackSpec];
            }
            ASLayout *layout = [finalSpec layoutThatFits:_sizeRangeForCollectionLayout(context.viewportSize, isDirectionVertical)];
            state = [[ASCollectionLayoutState alloc] initWithContext:context layout:layout getElementBlock:^ASCollectionElement * _Nullable(ASLayout * _Nonnull subly) {
                ASCellNode *node = ASDynamicCast(subly.layoutElement, ASCellNode);
                return node ? node.collectionElement : nil;
            }];
            break;
        }
            
        default:
            state = [[ASCollectionLayoutState alloc] initWithContext:context];
            break;
    }
    return state;
}

#pragma mark - private

+ (NSUInteger)_tallestColumnIndexInSection:(NSUInteger)section withColumnHeights:(NSArray *)columnHeights
{
    __block NSUInteger index = 0;
    __block CGFloat tallestHeight = 0.;
    [columnHeights[section] enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.floatValue > tallestHeight) {
            index = idx;
            tallestHeight = obj.floatValue;
        }
    }];
    return index;
}

+ (NSUInteger)_shortestColumnIndexInSection:(NSUInteger)section withColumnHeights:(NSArray *)columnHeights
{
    __block NSUInteger index = 0;
    __block CGFloat shortestHeight = CGFLOAT_MAX;
    [columnHeights[section] enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.floatValue < shortestHeight) {
            index = idx;
            shortestHeight = obj.floatValue;
        }
    }];
    return index;
}

+ (ASSizeRange)_sizeRangeForItem:(ASCellNode *)item
                     atIndexPath:(NSIndexPath *)indexPath
                 withLayoutWidth:(CGFloat)layoutWidth
                            info:(JTCollectionLayoutInfo *)info
             isDirectionVertical:(BOOL)isDirectionVertical
{
    if (isDirectionVertical) {
        CGFloat itemWidth = [self _columnWidthForSection:indexPath.section withLayoutWidth:layoutWidth info:info];
        return ASSizeRangeMake(CGSizeMake(itemWidth, 0), CGSizeMake(itemWidth, INFINITY));
    } else {
        CGFloat itemWidth = [self _columnHeightForSection:indexPath.section withLayoutWidth:layoutWidth info:info];
        return ASSizeRangeMake(CGSizeMake(0, itemWidth), CGSizeMake(INFINITY, itemWidth));
    }
}

+ (ASSizeRange)_sizeRangeForHeaderOfSection:(NSInteger)section
                            withLayoutWidth:(CGFloat)layoutWidth
                                     height:(CGFloat)height
                                       info:(JTCollectionLayoutInfo *)info
                        isDirectionVertical:(BOOL)isDirectionVertical
{
    if (isDirectionVertical) {
        return ASSizeRangeMake(CGSizeMake(0, height), CGSizeMake([self _widthForSection:section withLayoutWidth:layoutWidth info:info], height));
    } else {
        return ASSizeRangeMake(CGSizeMake(height, 0), CGSizeMake(height, [self _heightForSection:section withLayoutWidth:layoutWidth info:info]));
    }
}

+ (CGFloat)_widthForSection:(NSUInteger)section withLayoutWidth:(CGFloat)layoutWidth info:(JTCollectionLayoutInfo *)info
{
    return layoutWidth - info.sectionInsets.left - info.sectionInsets.right;
}

+ (CGFloat)_heightForSection:(NSUInteger)section withLayoutWidth:(CGFloat)layoutWidth info:(JTCollectionLayoutInfo *)info
{
    return layoutWidth - info.sectionInsets.top - info.sectionInsets.bottom;
}

+ (CGFloat)_columnWidthForSection:(NSUInteger)section withLayoutWidth:(CGFloat)layoutWidth info:(JTCollectionLayoutInfo *)info
{
    return ([self _widthForSection:section withLayoutWidth:layoutWidth info:info] - (info.numberOfColumn - 1) * info.interItemSpace) / info.numberOfColumn;
}

+ (CGFloat)_columnHeightForSection:(NSUInteger)section withLayoutWidth:(CGFloat)layoutWidth info:(JTCollectionLayoutInfo *)info
{
    return ([self _heightForSection:section withLayoutWidth:layoutWidth info:info] - (info.numberOfColumn - 1) * info.interItemSpace) / info.numberOfColumn;
}

ASSizeRange _sizeRangeForCollectionLayout(CGSize viewportSize, BOOL isDirectionVertical)
{
    ASSizeRange sizeRange = ASSizeRangeUnconstrained;
    if (isDirectionVertical) {
      sizeRange.min.width = viewportSize.width;
      sizeRange.max.width = viewportSize.width;
    } else {
      sizeRange.min.height = viewportSize.height;
      sizeRange.max.height = viewportSize.height;
    }
    return sizeRange;
}

@end
