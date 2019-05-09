//
//  JTFormInlineCellDelegate.h
//  JTForm
//
//  Created by dqh on 2019/4/25.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JTRowDescriptor;

@protocol JTFormInlineCellDelegate <NSObject>
@required
@property (nonatomic, weak) JTRowDescriptor *connectedRowDescriptor;
@end

NS_ASSUME_NONNULL_END
