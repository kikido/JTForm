//
//  JTFormValidateObject.h
//  JTForm
//
//  Created by dqh on 2019/5/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JTRowDescriptor;

@interface JTFormValidateObject : NSObject
@property (nonatomic, copy) NSString *errorMsg;
@property (nonatomic, assign) BOOL valid;
@property (nonatomic, strong) JTRowDescriptor *rowDescriptor;

- (instancetype)initWithErrorMsg:(NSString *)errorMsg valid:(BOOL)valid;

+ (instancetype)formValidateObjectWithErrorMsg:(NSString *)errorMsg valid:(BOOL)valid;
@end

NS_ASSUME_NONNULL_END
