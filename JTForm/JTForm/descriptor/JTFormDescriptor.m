//
//  JTFormDescriptor.m
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTFormDescriptor.h"

@implementation JTFormDescriptor

- (instancetype)init
{
    if (self = [super init]) {
        _formSections = @[].mutableCopy;
        _allSections = @[].mutableCopy;
        _allRowsByTag = @{}.mutableCopy;
        
        _addAsteriskToRequiredRowsTitle = false;
    }
    return self;
}

+ (nonnull instancetype)formDescriptor
{
    return [[[self class] alloc] init];
}

#pragma mark - helper

- (void)addRowToTagCollection:(JTRowDescriptor *)row
{
    if ([row.tag jt_isNotEmpty]) {
        self.allRowsByTag[row.tag] = row;
    }
}
@end
