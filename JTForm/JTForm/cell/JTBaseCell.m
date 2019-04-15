//
//  JTBaseCell.m
//  JTForm
//
//  Created by dqh on 2019/4/10.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTBaseCell.h"

@implementation JTBaseCell

- (instancetype)init
{
    if (self = [super init]) {
        [self config];
    }
    return self;
}

- (void)config
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"subclass must override this method 'config'" userInfo:nil];
}

- (void)update
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"subclass must override this method 'update'" userInfo:nil];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"subclass must override this method 'update'" userInfo:nil];
}


@end
