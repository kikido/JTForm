//
//  JTRowDescriptor.m
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTRowDescriptor.h"
#import "JTBaseCell.h"
#import "JTForm.h"

NSString *const JTFormRowTypeText = @"JTFormRowTypeText";
NSString *const JTFormRowTypeName = @"JTFormRowTypeName";
NSString *const JTFormRowTypeEmail = @"JTFormRowTypeEmail";
NSString *const JTFormRowTypeNumber = @"JTFormRowTypeNumber";
NSString *const JTFormRowTypeInteger = @"JTFormRowTypeInteger";
NSString *const JTFormRowTypeDecimal = @"JTFormRowTypeDecimal";
NSString *const JTFormRowTypePassword = @"JTFormRowTypePassword";
NSString *const JTFormRowTypePhone = @"JTFormRowTypePhone";
NSString *const JTFormRowTypeURL = @"JTFormRowTypeURL";
NSString *const JTFormRowTypeTextView = @"JTFormRowTypeTextView";

@interface JTRowDescriptor ()
@property (nonatomic, strong) JTBaseCell *cell;
@end

@implementation JTRowDescriptor

@synthesize hidden = _hidden;

+ (instancetype)formRowDescriptorWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title
{
    return [[JTRowDescriptor alloc] initWithTag:tag rowType:rowType title:title];
}

- (instancetype)initWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title
{
    if (self = [super init]) {
        _title = title;
        _rowType = rowType;
        _tag = tag;        
    }
    return self;
}

#pragma mark - cell

- (JTBaseCell *)cellInForm
{
    if (!_cell) {
        id cellClass = [JTForm cellClassesForRowDescriptorTypes][self.rowType];
        NSAssert(cellClass, @"not defined cell like:%@",self.rowType ?: @"null");
        
        if ([cellClass isKindOfClass:[NSString class]]) {
            NSString *cellClassString = cellClass;
            _cell = [[NSClassFromString(cellClassString) alloc] init];
        } else {
            _cell = [[cellClass alloc] init];
        }
        _cell.rowDescriptor = self;
        NSAssert([_cell isKindOfClass:[JTBaseCell class]], @"cell must extend from JTBaseCell");

        [self configureCellAtCreationTime];
    }
    return _cell;
}

- (void)configureCellAtCreationTime
{
    [self.cellConfigAtConfigure enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.cell setValue:(obj == [NSNull null]) ? nil : obj forKeyPath:key];
    }];
}

#pragma mark - hidden

- (void)setHidden:(BOOL)hidden
{
    _hidden = hidden;
    
    [self.sectionDescriptor evaluateFormRowIsHidden:self];
}

@end


@implementation JTRowAction

@end
