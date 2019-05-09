//
//  JTFormValidateObject.h
//  JTForm
//
//  Created by dqh on 2019/5/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTFormValidateObject : NSObject
/** 错误提示 */
@property (nonatomic, copy) NSString *errorMsg;
/** 是否通过验证 */
@property (nonatomic, assign) BOOL valid;

- (instancetype)initWithErrorMsg:(NSString *)errorMsg valid:(BOOL)valid;

+ (instancetype)formValidateObjectWithErrorMsg:(NSString *)errorMsg valid:(BOOL)valid;
@end

NS_ASSUME_NONNULL_END
