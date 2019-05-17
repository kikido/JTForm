//
//  JTFormRefreshDelegate.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/ASTableNode.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JTFormTailLoadDelegate <NSObject>

- (void)tailLoadWithContent:(ASBatchContext *)context;

@end

NS_ASSUME_NONNULL_END
