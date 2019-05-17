//
//  ASDisplayNode+JTFormAdditions.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
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
