//
//  ASDisplayNode+JTFormAdditions.m
//  JTForm
//
//  Created by dqh on 2019/4/15.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "ASDisplayNode+JTFormAdditions.h"

@implementation ASDisplayNode (JTFormAdditions)

- (ASDisplayNode *)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (ASDisplayNode *subNode in self.subnodes) {
        ASDisplayNode *firstResponder = [subNode findFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    return nil;
}

@end
