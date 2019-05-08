//
//  JTFormValidateProtocol.h
//  JTForm
//
//  Created by dqh on 2019/5/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTFormValidateObject.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JTFormValidateProtocol <NSObject>
- (JTFormValidateObject *)isValid:(JTRowDescriptor *)rowDescriptor;
@end

NS_ASSUME_NONNULL_END
