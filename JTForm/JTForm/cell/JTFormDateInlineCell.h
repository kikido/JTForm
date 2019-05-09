//
//  JTFormDateInlineCell.h
//  JTForm
//
//  Created by dqh on 2019/4/25.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTFormDateInlineCell : JTBaseCell <JTFormInlineCellDelegate>
@property (nonatomic, strong, readonly) UIDatePicker *datePicker;
@end

NS_ASSUME_NONNULL_END
