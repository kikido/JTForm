//
//  JTFormOptionsViewController.h
//  JTForm
//
//  Created by dqh on 2019/4/23.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTFormSelectViewControllerDelegate.h"

#if __has_include (<AsyncDisplayKit/AsyncDisplayKit.h>)
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class ASViewController;

@interface JTFormOptionsViewController : ASViewController <JTFormSelectViewControllerDelegate>

- (instancetype)initWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle;

@end

NS_ASSUME_NONNULL_END
