//
//  JTOptionObject.h
//  JTForm
//
//  Created by dqh on 2019/4/22.
//  Copyright © 2019 dqh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTOptionObject : NSObject

@property (nonatomic, copy) NSString *formDisplayText;

@property (nonatomic, assign) id formValue;

+(JTOptionObject *)formOptionsObjectWithValue:(nonnull id)value displayText:(nonnull NSString *)displayText;

+ (NSArray<JTOptionObject *> *)formOptionsObjectsWithValues:(nonnull NSArray *)values displayTexts:(nonnull NSArray *)displayTexts;

- (BOOL)isEqualToOptionObject:(JTOptionObject *)optionObject;

@end

NS_ASSUME_NONNULL_END
