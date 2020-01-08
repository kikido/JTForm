//
//  JTCollectionLayoutInfo.h
//  JTFormDemo
//
//  Created by dqh on 2019/12/18.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AsyncDisplayKit/ASScrollDirection.h>
#import "JTFormDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTCollectionLayoutInfo : NSObject

@property (nonatomic, strong) NSArray *headerHeights;
@property (nonatomic, strong) NSArray *footerHeights;

//@property (nonatomic, assign, readonly) NSInteger numberOfColumn;
//@property (nonatomic, assign, readonly) CGFloat interItemSpace;
//@property (nonatomic, assign, readonly) CGFloat lineSpace;
//@property (nonatomic, assign, readonly) CGSize itemSize;
//@property (nonatomic, assign, readonly) UIEdgeInsets sectionInsets;
//@property (nonatomic, assign, readonly) JTFormType formType;
//@property (nonatomic, assign, readonly) JTFormScrollDirection scrollDirection;
@property (nonatomic, assign) NSInteger numberOfColumn;
@property (nonatomic, assign) CGFloat interItemSpace;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) UIEdgeInsets sectionInsets;
@property (nonatomic, assign) JTFormType formType;
@property (nonatomic, assign) JTFormScrollDirection scrollDirection;


- (instancetype)initWithNumberOfColumn:(NSInteger)numberOfColumn
                         headerHeights:(NSArray *)headerHeights
                         footerHeights:(NSArray *)footerHeights
                           columnSpace:(CGFloat)interItemSpace
                             lineSpace:(CGFloat)lineSpace
                              itemSize:(CGSize)itemSize
                         sectionInsets:(UIEdgeInsets)sectionInsets
                                  type:(JTFormType)formType
                       scrollDirection:(JTFormScrollDirection)scrollDirection;

- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END
