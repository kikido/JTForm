//
//  JTFormNavigationAccessoryView.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTFormNavigationAccessoryView : UIToolbar
@property (nonatomic, strong) UIBarButtonItem *previousButton;
@property (nonatomic, strong) UIBarButtonItem *nextButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@end

NS_ASSUME_NONNULL_END
