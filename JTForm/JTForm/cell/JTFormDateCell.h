//
//  JTFormDateCell.h
//  JTForm
//
//  Created by dqh on 2019/4/25.
//  Copyright © 2019 dqh. All rights reserved.
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
