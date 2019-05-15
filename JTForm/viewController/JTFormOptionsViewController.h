//
//  JTFormOptionsViewController.h
//  JTForm
//
//  Created by dqh on 2019/4/23.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <Texture/AsyncDisplayKit/AsyncDisplayKit.h>
#import "JTFormSelectViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTFormOptionsViewController : ASViewController <JTFormSelectViewControllerDelegate>

- (instancetype)initWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle;

@end

NS_ASSUME_NONNULL_END
