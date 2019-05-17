//
//  JTFormFloatTextCell.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTBaseCell.h"
#import "JVFloatLabeledTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTFormFloatTextCell : JTBaseCell
@property (nonatomic, strong) JVFloatLabeledTextField *textField;
@end

NS_ASSUME_NONNULL_END
