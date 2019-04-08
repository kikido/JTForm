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




@end
