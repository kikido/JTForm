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

NSString *const JTFormRowTypeDefault = @"JTFormRowTypeDefault";

NSString *const JTFormRowTypeText = @"JTFormRowTypeText";
NSString *const JTFormRowTypeName = @"JTFormRowTypeName";
NSString *const JTFormRowTypeEmail = @"JTFormRowTypeEmail";
/** 数字以及符号 */
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
NSString *const JTFormRowTypePushButton = @"JTFormRowTypePushButton";

NSString *const JTFormRowTypeDate = @"JTFormRowTypeDate";
NSString *const JTFormRowTypeTime = @"JTFormRowTypeTime";
NSString *const JTFormRowTypeDateTime = @"JTFormRowTypeDateTime";
NSString *const JTFormRowTypeCountDownTimer = @"JTFormRowTypeCountDownTimer";
NSString *const JTFormRowTypeDateInline = @"JTFormRowTypeDateInline";

NSString *const JTFormRowTypeInlineDatePicker = @"JTFormRowTypeInlineDatePicker";

NSString *const JTFormRowTypeSwitch = @"JTFormRowTypeSwitch";
NSString *const JTFormRowTypeCheck = @"JTFormRowTypeCheck";
NSString *const JTFormRowTypeStepCounter = @"JTFormRowTypeStepCounter";
NSString *const JTFormRowTypeSegmentedControl = @"JTFormRowTypeSegmentedControl";
NSString *const JTFormRowTypeSlider = @"JTFormRowTypeSlider";
NSString *const JTFormRowTypeButton = @"JTFormRowTypeButton";

NSString *const JTFormRowTypeFloatText = @"JTFormRowTypeFloatText";

CGFloat const JTFormRowInitialHeight = -2.0;
CGFloat const JTFormUnspecifiedCellHeight = -3.0;


@interface JTRowDescriptor ()
@property (nonatomic, strong) JTBaseCell *cell;
@property (nonatomic, strong) NSMutableArray<id<JTFormValidateProtocol>> *validators;
@end

@implementation JTRowDescriptor

@synthesize hidden = _hidden;
@synthesize disabled = _disabled;

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
        
        _cellConfigAfterUpdate = @{}.mutableCopy;
        _cellConfigWhenDisabled = @{}.mutableCopy;
        _cellConfigAtConfigure = @{}.mutableCopy;
        _cellDataDictionary = @{}.mutableCopy;
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
#pragma mark - disable

- (BOOL)disabled
{
    if (self.sectionDescriptor.formDescriptor.disabled) {
        return YES;
    }
    if (self.sectionDescriptor.disabled) {
        return YES;
    }
    return _disabled;
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
            return [self.value cellText];
        }
    } else {
        return nil;
    }
}

- (nullable NSString *)editTextValue
{
    if (self.value) {
        return [self.value cellText];
    } else {
        return nil;
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[rowDescriptor] <%@: %p> rowtype:%@ , tag:%@, value:%@",[self class], &self, self.rowType, self.tag, self.value];
}

#pragma mark - Validation

- (void)addValidator:(nonnull id<JTFormValidateProtocol>)validator
{
    if (validator == nil || ![validator conformsToProtocol:@protocol(JTFormValidateProtocol)]) {
        return;
    }
    if (!_validators) {
        _validators = @[].mutableCopy;
    }
    if(![self.validators containsObject:validator]) {
        [self.validators addObject:validator];
    }
}

- (void)removeValidator:(nonnull id<JTFormValidateProtocol>)validator;
{
    if (validator == nil|| ![validator conformsToProtocol:@protocol(JTFormValidateProtocol)]) {
        return;
    }
    if ([self.validators containsObject:validator]) {
        [self.validators removeObject:validator];
    }
}

- (nullable JTFormValidateObject *)doValidate
{
    __block JTFormValidateObject *validateObject = nil;
    
    if (self.required) {
        if ([self rowValueIsEmpty]) {
            NSString *errorMsg = nil;
            if (self.requireMsg != nil) {
                errorMsg = self.requireMsg;
            } else {
                if (self.title != nil) {
                    errorMsg = [NSString stringWithFormat:@"%@ %@", self.title, [NSString jt_localizedStringForKey:@"can't empty"]];
                } else {
                    errorMsg = [NSString stringWithFormat:@"%@ %@", self.tag, [NSString jt_localizedStringForKey:@"can't empty"]];
                }
            }
            validateObject = [JTFormValidateObject formValidateObjectWithErrorMsg:errorMsg valid:NO];
            return validateObject;
        }
    }
    [self.validators enumerateObjectsUsingBlock:^(id<JTFormValidateProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JTFormValidateObject *vObject = [obj isValid:self];
        if (vObject && !vObject.valid) {
            validateObject = vObject;
            *stop = YES;
        }
    }];
    return validateObject;
}

- (BOOL)rowValueIsEmpty
{
    if (!self.value || [self.value isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([self.value isKindOfClass:[NSString class]] && [[self.value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    if ([self.value isKindOfClass:[NSArray class]] && [self.value count] == 0) {
        return YES;
    }
    return NO;
}

@end


@implementation JTRowAction

@end
