//
//  JTBaseDescriptor.h
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JTHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTBaseDescriptor : NSObject


/** 背景颜色。默认为空，即使用默认颜色。当不为空时，优先级为row > section > form */
@property (nonatomic, strong) UIColor *bgColor;

/** Bool值，决定是否隐藏当前的控件(单元行，节，以及整个表单) */
@property (nonatomic, assign) BOOL hidden;

/** Bool值，决定当前控件是否接受响应事件。如果为YES，则不能编辑当前控件内容，仅仅作为展示用 */
@property (nonatomic, assign) BOOL disabled;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
