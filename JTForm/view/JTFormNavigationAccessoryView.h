//
//  JTFormNavigationAccessoryView.h
//  JTForm
//
//  Created by dqh on 2019/4/18.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTFormNavigationAccessoryView : UIToolbar
@property (nonatomic, strong) UIBarButtonItem *previousButton;
@property (nonatomic, strong) UIBarButtonItem *nextButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@end

NS_ASSUME_NONNULL_END
