//
//  JTRowDescriptor.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTRowDescriptor.h"
#import "JTForm.h"

NSString *const JTFormRowTypeText                 = @"JTFormRowTypeText";
NSString *const JTFormRowTypeName                 = @"JTFormRowTypeName";
/** A type optimized for multiple email address entry (shows space @ . prominently). */
NSString *const JTFormRowTypeEmail                = @"JTFormRowTypeEmail";
/** Numbers and assorted punctuation 数字和符号 */
NSString *const JTFormRowTypeNumber               = @"JTFormRowTypeNumber";
NSString *const JTFormRowTypeInteger              = @"JTFormRowTypeInteger";
NSString *const JTFormRowTypeDecimal              = @"JTFormRowTypeDecimal";
NSString *const JTFormRowTypePassword             = @"JTFormRowTypePassword";
NSString *const JTFormRowTypePhone                = @"JTFormRowTypePhone";
NSString *const JTFormRowTypeURL                  = @"JTFormRowTypeURL";
NSString *const JTFormRowTypeTextView             = @"JTFormRowTypeTextView";
NSString *const JTFormRowTypeInfo                 = @"JTFormRowTypeInfo";
NSString *const JTFormRowTypeLongInfo             = @"JTFormRowTypeLongInfo";
NSString *const JTFormRowTypePushSelect           = @"JTFormRowTypePushSelect";
NSString *const JTFormRowTypeMultipleSelect       = @"JTFormRowTypeMultipleSelect";
NSString *const JTFormRowTypeSheetSelect          = @"JTFormRowTypeSheetSelect";
NSString *const JTFormRowTypeAlertSelect          = @"JTFormRowTypeAlertSelect";
NSString *const JTFormRowTypePickerSelect         = @"JTFormRowTypePickerSelect";
NSString *const JTFormRowTypePushButton           = @"JTFormRowTypePushButton";
NSString *const JTFormRowTypeDate                 = @"JTFormRowTypeDate";
NSString *const JTFormRowTypeTime                 = @"JTFormRowTypeTime";
NSString *const JTFormRowTypeDateTime             = @"JTFormRowTypeDateTime";
NSString *const JTFormRowTypeCountDownTimer       = @"JTFormRowTypeCountDownTimer";
NSString *const JTFormRowTypeDateInline           = @"JTFormRowTypeDateInline";
NSString *const JTFormRowTypeTimeInline           = @"JTFormRowTypeTimeInline";
NSString *const JTFormRowTypeDateTimeInline       = @"JTFormRowTypeDateTimeInline";
NSString *const JTFormRowTypeCountDownTimerInline = @"JTFormRowTypeCountDownTimerInline";
NSString *const JTFormRowTypeSwitch               = @"JTFormRowTypeSwitch";
NSString *const JTFormRowTypeCheck                = @"JTFormRowTypeCheck";
NSString *const JTFormRowTypeStepCounter          = @"JTFormRowTypeStepCounter";
NSString *const JTFormRowTypeSegmentedControl     = @"JTFormRowTypeSegmentedControl";
NSString *const JTFormRowTypeSlider               = @"JTFormRowTypeSlider";
NSString *const JTFormRowTypeFloatText            = @"JTFormRowTypeFloatText";

CGFloat const JTFormRowInitialHeight = -2.0;
CGFloat const JTFormUnspecifiedCellHeight = -3.0;


@interface JTRowDescriptor ()
// FIXME:ASCellNode不要强引用
@property (nonnull, nonatomic, strong)  JTBaseCell *cell;
@property (nullable, nonatomic, strong) NSMutableArray<id<JTFormValidateProtocol>> *validators;
@end

@implementation JTRowDescriptor

@synthesize hidden = _hidden;
@synthesize disabled = _disabled;

+ (instancetype)rowDescriptorWithTag:(nullable id<NSCopying>)tag rowType:(nonnull JTFormRowType)rowType title:(nullable NSString *)title
{
    return [[JTRowDescriptor alloc] initWithTag:tag rowType:rowType title:title];
}

- (instancetype)initWithTag:(nullable id<NSCopying>)tag rowType:(nonnull JTFormRowType)rowType title:(nullable NSString *)title
{
    if (self = [super init]) {
        _title   = title;
        _rowType = rowType;
        _tag     = tag;
        _height  = JTFormRowInitialHeight;
        
        _configAfterUpdate  = @{}.mutableCopy;
        _configAfterConfig  = @{}.mutableCopy;
        _configWhenDisabled = @{}.mutableCopy;
        _configReserve      = @{}.mutableCopy;
       
        [self addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"value"];
}

#pragma mark - cell

- (void)updateCell
{
    if (!self.isCellExist || !self.sectionDescriptor.formDescriptor.form) {
        return;
    }
    JTBaseCell *cell = [self cellForDescriptor];
    [cell update];
    [self.configAfterUpdate enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [cell setValue:(obj == [NSNull null] ? nil : obj) forKeyPath:key];
    }];
    if (cell.rowDescriptor.disabled) {
        [self.configWhenDisabled enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [cell setValue:(obj == [NSNull null] ? nil : obj) forKeyPath:key];
        }];
    }
}

- (void)reloadCellWithNewRowType:(nonnull JTFormRowType)rowType
{
    NSAssert([JTForm cellClassesForRowTypes][rowType] != nil, @"rowtype:%@ did not existed in JTForm cellClassesForRowTypes", rowType);
    
    _rowType = rowType;
    _cell = nil;
    _cell = [self cellForDescriptor];
    [((JTForm *)self.sectionDescriptor.formDescriptor.form) reloadRows:@[self]];
}

- (JTBaseCell *)cellForDescriptor
{
    if (!_cell) {
        id cellClass = [JTForm cellClassesForRowTypes][self.rowType];
        NSAssert(cellClass, @"no defined cell class for cell type named %@", self.rowType ?: @"null");
        
        if ([cellClass isKindOfClass:[NSString class]]) {
            NSString *cellClassString = cellClass;
            _cell = [[NSClassFromString(cellClassString) alloc] init];
        } else {
            _cell = [[cellClass alloc] init];
        }
        NSAssert([_cell isKindOfClass:[JTBaseCell class]], @"cell must extend from JTBaseCell");
        _cell.rowDescriptor = self;
        _cellExist = true;
        
        [self.configAfterConfig enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self.cell setValue:(obj == [NSNull null]) ? nil : obj forKeyPath:key];
        }];
    }
    return _cell;
}

- (CGFloat)height
{
    // 初始化高度
    // 第一次初始化时，先看看 cell 有没有重写协议方法 ‘+formCellHeightForRowDescriptor’，如果没有的话则自动布局
    if (_height == JTFormRowInitialHeight) {
        if ([[self.cell class] respondsToSelector:@selector(formCellHeightForRowDescriptor:)]) {
            return [[self.cell class] formCellHeightForRowDescriptor:self];
        } else {
            // 没有指定高度，则设置为自动布局
            return JTFormUnspecifiedCellHeight;
        }
    }
    return _height;
}

#pragma mark - disable

- (BOOL)disabled
{
    if (self.sectionDescriptor.disabled || self.sectionDescriptor.formDescriptor.disabled) {
        return YES;
    }
    return _disabled;
}

- (void)setDisabled:(BOOL)disabled
{
    if (_disabled != disabled) {
        _disabled = disabled;
        if (disabled && self.isCellExist) {
            JTBaseCell *cell = [self cellForDescriptor];
            if ([cell jt_isFirstResponder]) {
                [cell resignFirstResponder];
            }
            [self updateCell];
        }
    }
}

#pragma mark - hidden

- (void)setHidden:(BOOL)hidden
{
    if (hidden != _hidden) {
        _hidden = hidden;
        [self.sectionDescriptor evaluateFormRowIsHidden:self];
    }
}

#pragma mark - text

- (nullable NSString *)unEditingText
{
    if (self.value) {
        if (self.valueFormatter) {
            return [self.valueFormatter stringForObjectValue:self.value];
        }
        else {
            return [self.value descriptionForForm];
        }
    }
    else {
        return nil;
    }
}

- (nullable NSString *)editingText
{   
    return [self.value descriptionForForm];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[rowDescriptor]<%@: %p> rowtype:%@, tag:%@, value:%@",[self class], self, _rowType, _tag, _value];
}

#pragma mark - Validation

- (void)addValidator:(nonnull id<JTFormValidateProtocol>)validator
{
    if (!validator) return;
    if (![validator conformsToProtocol:@protocol(JTFormValidateProtocol)]) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:[NSString stringWithFormat:@"validator %@ should conform protocol JTFormValidateProtocol", [validator class]]
                                     userInfo:nil];
    }
    if (!_validators) {
        _validators = [NSMutableArray array];
    }
    if(![_validators containsObject:validator]) {
        [_validators addObject:validator];
    }
}

- (void)removeValidator:(nonnull id<JTFormValidateProtocol>)validator;
{
    [_validators removeObject:validator];
}

- (void)removeAllValidators
{
    [_validators removeAllObjects];
    _validators = nil;
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
                    errorMsg = [NSString stringWithFormat:@"%@ %@", self.title, [NSString jt_localizedStringForKey:@"JTForm_ValueCantEmpty"]];
                } else {
                    errorMsg = [NSString stringWithFormat:@"%@ %@", self.tag, [NSString jt_localizedStringForKey:@"JTForm_ValueCantEmpty"]];
                }
            }
            validateObject = [JTFormValidateObject formValidateObjectWithErrorMsg:errorMsg valid:NO];
            return validateObject;
        }
    }
    __weak typeof(self) weakSelf = self;
    [self.validators enumerateObjectsUsingBlock:^(id<JTFormValidateProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        JTFormValidateObject *vObject = [obj isValid:strongSelf];
        validateObject = vObject;
        if (vObject && !vObject.valid) {
            *stop = YES;
        }
    }];
    return validateObject;
}

- (BOOL)rowValueIsEmpty
{
    return [self _sourceRowValueIsEmpty:self.value];
}

- (BOOL)_sourceRowValueIsEmpty:(id)objectValue
{
    if (!objectValue || [objectValue isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([objectValue isKindOfClass:[NSString class]] && [[objectValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    if ([objectValue isKindOfClass:[NSArray class]] && [objectValue count] == 0) {
        return YES;
    }
    if ([objectValue isKindOfClass:[NSDictionary class]] && [[objectValue allKeys] count] == 0) {
        return YES;
    }
    if ([objectValue isKindOfClass:[JTOptionObject class]]) {
        return  [self _sourceRowValueIsEmpty:[objectValue optionValue]];
    }
    return NO;
}

#pragma mark - property

- (JTRowAction *)action
{
    if (!_action) {
        _action = [[JTRowAction alloc] init];
    }
    return _action;
}

#pragma mark - kvo

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    if ([key isEqualToString:@"value"]) {
        return false;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

- (void)manualSetValue:(nullable id)value
{
    [self willChangeValueForKey:@"value"];
    _value = value;
    [self didChangeValueForKey:@"value"];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!self.sectionDescriptor.formDescriptor.form) return;
    
    if ([keyPath isEqualToString:@"value"]) {
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]) {
            id newValue = [change objectForKey:NSKeyValueChangeNewKey];
            id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
            if (self.valueChangeBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.valueChangeBlock(oldValue, newValue, self);
                });
            }
            if ([self.sectionDescriptor.formDescriptor.form respondsToSelector:@selector(formRowDescriptorValueHasChanged:oldValue:newValue:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.sectionDescriptor.formDescriptor.form formRowDescriptorValueHasChanged:self oldValue:oldValue newValue:newValue];
                });
            }
        }
    }
}

@end


@implementation JTRowAction
@end
