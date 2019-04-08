//
//  JTRowDescriptor.m
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTRowDescriptor.h"
#import "JTHelper.h"

@implementation JTRowDescriptor

+ (instancetype)formRowDescriptorWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title
{
    return [[JTRowDescriptor alloc] initWithTag:tag rowType:rowType title:title];
}

- (instancetype)initWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title
{
    if (self = [super init]) {
        NSAssert([tag jt_isEmpty], @"tag can not empty");
        NSAssert([rowType jt_isEmpty], @"rowType can not empty");
        
        _title = title;
        _
    }
    return self;
}


@end
