//
//  NSObject+JTFormHelper.h
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (JTFormHelper)

- (id)valueData;

- (BOOL)jt_isEmpty;

- (NSString *)displayText;
@end

NS_ASSUME_NONNULL_END
