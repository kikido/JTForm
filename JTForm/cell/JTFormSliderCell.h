//
//  JTFormSliderCell.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTFormSliderCell : JTBaseCell
@property (nonatomic, assign) NSUInteger steps;
@property (nonatomic, assign) CGFloat maximumValue;
@property (nonatomic, assign) CGFloat minimumValue;
@property (nonatomic, strong) UISlider *slider;
@end

NS_ASSUME_NONNULL_END
