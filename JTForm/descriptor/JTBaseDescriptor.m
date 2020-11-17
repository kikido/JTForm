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
        _hidden = false;
        _disabled = false;
    }
    return self;
}

- (JTFormConfigModel *)configModel
{
    if (!_configModel) {
        _configModel = [[JTFormConfigModel alloc] init];
    }
    return _configModel;;
}

@end


@implementation JTFormConfigModel
@end
