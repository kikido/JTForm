//
//  JTFormSliderCell.h
//  JTForm
//
//  Created by dqh on 2019/5/6.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTFormSliderCell : JTBaseCell
@property (nonatomic, assign) NSUInteger steps;
@property (nonatomic, strong) UISlider *sliderControl;
@end

NS_ASSUME_NONNULL_END
