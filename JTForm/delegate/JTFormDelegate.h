//
//  JTFormDelegate.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JTForm;
@class JTRowDescriptor;

@protocol JTFormDelegate <NSObject>

@optional

- (void)formRowDescriptorValueHasChanged:(JTForm *)form formRow:(JTRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue;

@end

NS_ASSUME_NONNULL_END
