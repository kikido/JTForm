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
NSString *const JTFormRowTypeInfo = @"JTFormRowTypeInfo";

NSString *const JTFormRowTypePushSelect = @"JTFormRowTypePushSelect";
NSString *const JTFormRowTypeMultipleSelect = @"JTFormRowTypeMultipleSelect";
NSString *const JTFormRowTypeSheetSelect = @"JTFormRowTypeSheetSelect";
NSString *const JTFormRowTypeAlertSelect = @"JTFormRowTypeAlertSelect";
NSString *const JTFormRowTypePickerSelect = @"JTFormRowTypePickerSelect";

NSString *const JTFormRowTypeDate = @"JTFormRowTypeDate";
NSString *const JTFormRowTypeTime = @"JTFormRowTypeTime";
NSString *const JTFormRowTypeDateTime = @"JTFormRowTypeDateTime";
NSString *const JTFormRowTypeCountDownTimer = @"JTFormRowTypeCountDownTimer";
NSString *const JTFormRowTypeDateInline = @"JTFormRowTypeDateInline";

NSString *const JTFormRowTypeInlineDatePicker = @"JTFormRowTypeInlineDatePicker";

CGFloat const JTFormRowInitialHeight = -2.0;
CGFloat const JTFormUnspecifiedCellHeight = -3.0;


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
        _height = JTFormRowInitialHeight;
        _action = [[JTRowAction alloc] init];
    }
    return self;
}

#pragma mark - cell

- (void)reloadCell
{
    _cell = nil;
    _cell = [self cellInForm];
}

- (JTBaseCell *)cellInForm
{
    if (!_cell) {
        id cellClass = [JTForm cellClassesForRowTypes][self.rowType];
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

- (CGFloat)height
{
    if (_height == JTFormRowInitialHeight) {
        if ([[self.cell class] respondsToSelector:@selector(formCellHeightForRowDescriptor:)]) {
            return [[self.cell class] formCellHeightForRowDescriptor:self];
        } else {
            //没有指定高度
            return JTFormUnspecifiedCellHeight;
        }
    }
    return _height;
}
#pragma mark - hidden

- (void)setHidden:(BOOL)hidden
{
    _hidden = hidden;
    
    [self.sectionDescriptor evaluateFormRowIsHidden:self];
}

#pragma mark - 文本

- (nullable NSString *)displayContentValue
{
    if (self.value) {
        if (self.valueFormatter) {
            return [self.valueFormatter stringForObjectValue:self.value];
        } else {
            return [self.value displayText];
        }
    } else {
        return nil;
    }
}

- (nullable NSString *)editTextValue
{
    if (self.value) {
        return [self.value displayText];
    } else {
        return nil;
    }
}

@end


@implementation JTRowAction

@end
