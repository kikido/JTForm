//
//  JTFormSelectViewControllerDelegate.h
//  JTForm
//
//  Created by dqh on 2019/4/23.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTForm.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JTFormSelectViewControllerDelegate <NSObject>
@required
@property (nonatomic, strong) JTRowDescriptor *rowDescriptor;
@property (nonatomic, strong) JTForm *form;
@end

NS_ASSUME_NONNULL_END
