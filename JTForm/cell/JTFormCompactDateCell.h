//
//  JTFormCompactDateCell.h
//  JTFormDemo
//
//  Created by dqh on 2020/9/24.
//  Copyright © 2020 dqh. All rights reserved.
//

#import "JTBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTFormCompactDateCell : JTBaseCell
@property (nonatomic, strong) NSDate    *minimumDate;
@property (nonatomic, strong) NSDate    *maximumDate;
@property (nonatomic, strong) NSLocale  *locale;
/** 分钟间隔。取值范围 1~30，必须要能被60整除 */
@property (nonatomic, strong) NSNumber  *minuteInterval;
@end

NS_ASSUME_NONNULL_END
