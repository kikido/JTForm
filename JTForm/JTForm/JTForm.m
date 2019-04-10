//
//  JTForm.m
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTForm.h"

@interface JTForm () <ASTableDelegate, ASTableDataSource>
@property (nonatomic, strong) ASTableNode *tableNode;
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
    return nil;
}

#pragma mark - ASTableDelegate

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (ASSizeRange)tableNode:(ASTableNode *)tableNode constrainedSizeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize max = CGSizeMake(0, 200);
    return ASSizeRangeMake(max);
}


@end
