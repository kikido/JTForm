//
//  JTFormInlineCellDelegate.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JTRowDescriptor;

@protocol JTFormInlineCellDelegate <NSObject>
@required
@property (nonatomic, weak) JTRowDescriptor *connectedRowDescriptor;
@end

NS_ASSUME_NONNULL_END
