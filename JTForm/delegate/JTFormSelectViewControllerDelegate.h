//
//  JTFormSelectViewControllerDelegate.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JTRowDescriptor;
@class JTForm;

@protocol JTFormSelectViewControllerDelegate <NSObject>
@required
@property (nonatomic, strong) JTRowDescriptor *rowDescriptor;
@property (nonatomic, strong) JTForm          *form;
@end

NS_ASSUME_NONNULL_END
