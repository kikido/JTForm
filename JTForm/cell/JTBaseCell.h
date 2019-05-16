//
//  JTBaseCell.h
//  JTForm
//
//  Created by dqh on 2019/4/10.
//  Copyright © 2019 dqh. All rights reserved.
//
#import "JTNetworkImageNode.h"
#import "JTForm.h"

@class JTRowDescriptor;
@class JTSectionDescriptor;

NS_ASSUME_NONNULL_BEGIN

@interface JTBaseCell : ASCellNode <JTBaseCellDelegate>
/** 行描述。数据源 */
@property (nonatomic, weak) JTRowDescriptor *rowDescriptor;

@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASTextNode *contentNode;
@property (nonatomic, strong) JTNetworkImageNode *imageNode;

- (JTForm *)findForm;

- (JTFormDescriptor *)findFormDescriptor;

- (UIColor *)formCellBgColor;

- (UIColor *)formCellTitleColor;

- (UIColor *)formCellContentColor;

- (UIColor *)formCellPlaceHolderColor;

- (UIColor *)formCellDisabledTitleColor;

- (UIColor *)formCellDisabledContentColor;

- (UIFont *)formCellTitleFont;

- (UIFont *)formCellContentFont;

- (UIFont *)formCellPlaceHlderFont;

- (UIFont *)formCellDisabledTitleFont;

- (UIFont *)formCellDisabledContentFont;

- (UIColor *)highLightTitleColor;

@end

NS_ASSUME_NONNULL_END
