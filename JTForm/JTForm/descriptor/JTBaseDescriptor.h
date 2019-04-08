//
//  JTBaseDescriptor.h
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTBaseDescriptor : NSObject


/** 背景颜色。默认为空，即使用默认颜色。当不为空时，优先级为row > section > form */
@property (nonatomic, strong) UIColor *bgColor;

@end

NS_ASSUME_NONNULL_END
