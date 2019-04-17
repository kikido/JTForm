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
    self.separatorInset= UIEdgeInsetsMake(0, 15., 0, 0);
    self.automaticallyManagesSubnodes = YES;
}

- (void)update
{
    
}

- (void)formCellHighlight
{
    
}

- (void)formCellUnhighlight
{

}

- (BOOL)formCellCanBecomeFirstResponder
{
    return NO;
}

- (BOOL)becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];
    // fixme
    return result;
}

- (BOOL)resignFirstResponder
{
    BOOL result = [super resignFirstResponder];
    return result;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"subclass must override this method 'update'" userInfo:nil];
}


@end
