//
//  JTBaseDescriptor.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTBaseDescriptor.h"

@implementation JTBaseDescriptor

- (instancetype)init
{
    if (self = [super init]) {
        _configMode = [[JTFormConfigMode alloc] init];
        _hidden = false;
        _disabled = false;
    }
    return self;
}

@end


@implementation JTFormConfigMode
@end
