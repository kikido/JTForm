//
//  JTRowDescriptor.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTRowDescriptor.h"
#import "JTBaseCell.h"
#import "JTForm.h"

NSString *const JTFormRowTypeText             = @"JTFormRowTypeText";
NSString *const JTFormRowTypeName             = @"JTFormRowTypeName";
NSString *const JTFormRowTypeEmail            = @"JTFormRowTypeEmail";
NSString *const JTFormRowTypeNumber           = @"JTFormRowTypeNumber";
NSString *const JTFormRowTypeInteger          = @"JTFormRowTypeInteger";
NSString *const JTFormRowTypeDecimal          = @"JTFormRowTypeDecimal";
NSString *const JTFormRowTypePassword         = @"JTFormRowTypePassword";
NSString *const JTFormRowTypePhone            = @"JTFormRowTypePhone";
NSString *const JTFormRowTypeURL              = @"JTFormRowTypeURL";
NSString *const JTFormRowTypeTextView         = @"JTFormRowTypeTextView";
NSString *const JTFormRowTypeInfo             = @"JTFormRowTypeInfo";
NSString *const JTFormRowTypePushSelect       = @"JTFormRowTypePushSelect";
NSString *const JTFormRowTypeMultipleSelect   = @"JTFormRowTypeMultipleSelect";
NSString *const JTFormRowTypeSheetSelect      = @"JTFormRowTypeSheetSelect";
NSString *const JTFormRowTypeAlertSelect      = @"JTFormRowTypeAlertSelect";
NSString *const JTFormRowTypePickerSelect     = @"JTFormRowTypePickerSelect";
NSString *const JTFormRowTypePushButton       = @"JTFormRowTypePushButton";
NSString *const JTFormRowTypeDate             = @"JTFormRowTypeDate";
NSString *const JTFormRowTypeTime             = @"JTFormRowTypeTime";
NSString *const JTFormRowTypeDateTime         = @"JTFormRowTypeDateTime";
NSString *const JTFormRowTypeCountDownTimer   = @"JTFormRowTypeCountDownTimer";
NSString *const JTFormRowTypeDateInline       = @"JTFormRowTypeDateInline";
NSString *const JTFormRowTypeSwitch           = @"JTFormRowTypeSwitch";
NSString *const JTFormRowTypeCheck            = @"JTFormRowTypeCheck";
NSString *const JTFormRowTypeStepCounter      = @"JTFormRowTypeStepCounter";
NSString *const JTFormRowTypeSegmentedControl = @"JTFormRowTypeSegmentedControl";
NSString *const JTFormRowTypeSlider           = @"JTFormRowTypeSlider";
NSString *const JTFormRowTypeButton           = @"JTFormRowTypeButton";
NSString *const JTFormRowTypeFloatText        = @"JTFormRowTypeFloatText";

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

+ (instancetype)rowDescriptorWithTag:(nullable NSString *)tag rowType:(nonnull JTFormRowType)rowType title:(nullable NSString *)title
{
    return [[JTRowDescriptor alloc] initWithTag:tag rowType:rowType title:title];
}

- (instancetype)initWithTag:(nullable NSString *)tag rowType:(nonnull JTFormRowType)rowType title:(nullable NSString *)title
{
    if (self = [super init]) {
        _title   = title;
        _rowType = rowType;
        _tag     = tag;
        _height  = JTFormRowInitialHeight;
        
        _cellConfigAfterUpdate  = @{}.mutableCopy;
        _cellConfigWhenDisabled = @{}.mutableCopy;
        _cellConfigAtConfigure  = @{}.mutableCopy;
        _cellDataDictionary     = @{}.mutableCopy;
        
        [self addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"value"];
}

#pragma mark - cell

- (void)updateUI
{
    if (!self.isCellExist || !self.sectionDescriptor.formDescriptor.form) {
        return;
    }
    JTBaseCell *cell = [self cellInForm];
    [cell update];
    [self.cellConfigAfterUpdate enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [cell setValue:(obj == [NSNull null] ? nil : obj) forKeyPath:key];
    }];
    if (cell.rowDescriptor.disabled) {
        [self.cellConfigWhenDisabled enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [cell setValue:(obj == [NSNull null] ? nil : obj) forKeyPath:key];
        }];
    }
}

- (void)reloadCellWithNewRowType:(nonnull JTFormRowType)rowType
{
    if (!rowType) return;
    if (![JTForm cellClassesForRowTypes][rowType]) return;
    
    _rowType = rowType;
    _cell = nil;
    _cell = [self cellInForm];
    [((JTForm *)self.sectionDescriptor.formDescriptor.form) reloadRows:@[self]];
}

- (JTBaseCell *)cellInForm
{
    if (!_cell) {
        id cellClass = [JTForm cellClassesForRowTypes][self.rowType];
        NSAssert(cellClass, @"not defined cell class for cell type named %@", self.rowType ?: @"null");
        
        if ([cellClass isKindOfClass:[NSString class]]) {
            NSString *cellClassString = cellClass;
            _cell = [[NSClassFromString(cellClassString) alloc] init];
        } else {
            _cell = [[cellClass alloc] init];
        }
        NSAssert([_cell isKindOfClass:[JTBaseCell class]], @"cell must extend from JTBaseCell");
        _cell.rowDescriptor = self;
        
        [self configureCellAtCreationTime];
        _cellExist = true;
    }
    return _cell;
}

- (void)configureCellAtCreationTime
{
    __weak typeof(self) weakSelf = self;
    [self.cellConfigAtConfigure enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.cell setValue:(obj == [NSNull null]) ? nil : obj forKeyPath:key];
    }];
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
    if (self.sectionDescriptor.formDescriptor.disabled) return YES;
    if (self.sectionDescriptor.disabled)                return YES;
    
    return _disabled;
}

- (void)setDisabled:(BOOL)disabled
{
    if (_disabled != disabled) {
        _disabled = disabled;
        if (disabled && self.isCellExist) {
            JTBaseCell *cell = [self cellInForm];
            // FIXME: JTFormRowTypeAlertSelect 设置 disabled 和 hidden 属性并不会让弹出的 UIAlertController 消失
            if ([cell isFirstResponder]) {
                [cell resignFirstResponder];
            }
        }
        [self updateUI];
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

- (nullable NSString *)displayTextValue
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
    if (!self.value) return nil;
    
    return [self.value cellText];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[rowDescriptor] <%@: %p> rowtype:%@, tag:%@, value:%@",[self class], self, _rowType, _tag, _value];
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
    [self.validators removeObject:validator];
}

- (void)removeAllValidators
{
    [self.validators removeAllObjects];
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
        if (vObject && !vObject.valid) {
            validateObject = vObject;
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
        return  [self _sourceRowValueIsEmpty:[objectValue formValue]];
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

#pragma mark - private

@end


@implementation JTRowAction
@end
