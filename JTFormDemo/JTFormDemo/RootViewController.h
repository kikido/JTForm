//
//  RootViewController.h
//  JTForm
//
//  Created by dqh on 2019/5/6.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTForm.h"

NS_ASSUME_NONNULL_BEGIN

@interface RootViewController : UIViewController
@property (nonatomic, strong) JTForm *form;

NSURL* netImageUrl(NSInteger width, NSInteger height);

@end

NS_ASSUME_NONNULL_END
