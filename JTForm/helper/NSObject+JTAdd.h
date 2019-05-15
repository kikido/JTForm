//
//  NSObject+JTFormHelper.h
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (JTAdd)

- (id)cellValue;

- (NSString *)cellText;

- (BOOL)jt_isEqual:(id)object;

- (BOOL)jt_contentIsNotEmpty;
@end

NS_ASSUME_NONNULL_END
