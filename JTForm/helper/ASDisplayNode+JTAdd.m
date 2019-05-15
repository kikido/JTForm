//
//  ASDisplayNode+JTFormAdditions.m
//  JTForm
//
//  Created by dqh on 2019/4/15.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "ASDisplayNode+JTAdd.h"
#import "JTBaseCell.h"

@implementation ASDisplayNode (JTAdd)

- (ASDisplayNode *)findFirstResponder
{
    if (self.view.isFirstResponder) {
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
