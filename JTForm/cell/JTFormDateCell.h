//
//  JTFormDateCell.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTFormDateCell : JTBaseCell
@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;
@property (nonatomic, assign) NSInteger minuteInterval;
@property (nonatomic, strong) NSLocale *locale;
@end

NS_ASSUME_NONNULL_END
