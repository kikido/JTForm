//
//  JTFormRefreshDelegate.h
//  JTForm
//
//  Created by dqh on 2019/5/9.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/ASTableNode.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JTFormTailLoadDelegate <NSObject>

- (void)tailLoadWithContent:(ASBatchContext *)context;

@end

NS_ASSUME_NONNULL_END
