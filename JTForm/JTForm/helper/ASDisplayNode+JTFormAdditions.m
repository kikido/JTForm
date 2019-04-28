//
//  ASDisplayNode+JTFormAdditions.m
//  JTForm
//
//  Created by dqh on 2019/4/15.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "ASDisplayNode+JTFormAdditions.h"
#import "JTBaseCell.h"

@implementation ASDisplayNode (JTFormAdditions)

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

- (JTBaseCell *)formCell
{
    if ([self isKindOfClass:[JTBaseCell class]]) {
        if ([self conformsToProtocol:@protocol(JTBaseCellDelegate)]){
            return (JTBaseCell<JTBaseCellDelegate> *)self;
        }
        return nil;
    }
    if (self.supernode) {
        JTBaseCell<JTBaseCellDelegate> *cell = [self.supernode formCell];
        if (cell != nil) {
            return cell;
        }
    }
    return nil;
}

@end
