//
//  JTOptionObject.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTOptionObject : NSObject
/** 选择项的展示文本 */
@property (nonatomic, copy  ) NSString *formDisplayText;
/** 选择项的值 */
@property (nonatomic, assign) id       formValue;

+(JTOptionObject *)formOptionsObjectWithValue:(nonnull id)value displayText:(nonnull NSString *)displayText;

+ (NSArray<JTOptionObject *> *)formOptionsObjectsWithValues:(nonnull NSArray *)values displayTexts:(nonnull NSArray *)displayTexts;

- (BOOL)isEqualToOptionObject:(JTOptionObject *)optionObject;

@end

NS_ASSUME_NONNULL_END
