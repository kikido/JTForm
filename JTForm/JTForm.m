//
//  JTForm.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTForm.h"
#import "JTBaseCell.h"
#import "JTFormTextFieldCell.h"
#import "JTFormTextViewCell.h"
#import "JTFormSelectCell.h"
#import "JTFormDateCell.h"
#import "JTFormDateInlineCell.h"
#import "JTFromSwitchCell.h"
#import "JTFormSegmentCell.h"
#import "JTFormSliderCell.h"
#import "JTFormFloatTextCell.h"
#import "JTFormCheckCell.h"
#import "JTFormStepCounterCell.h"
#import "JTFormNavigationAccessoryView.h"

typedef NS_ENUM(NSInteger, JTFormErrorCode) {
    JTFormErrorCodeInvalid = -999,
    JTFormErrorCodeRequired = -1000
};

NSString *const JTFormErrorDomain = @"JTFormErrorDomain";

@interface JTForm () <ASTableDelegate, ASTableDataSource, JTFormDescriptorDelegate>

@end

@implementation JTForm

- (instancetype)initWithDescriptor:(JTFormDescriptor *)formDescriptor
{
    if (self = [super initWithFrame:CGRectZero]) {
        _formDescriptor          = formDescriptor;
        _formDescriptor.delegate = self;
        [self initializeForm];
        [self addNotifications];
    }
    return self;
}

+ (instancetype)formWithDescriptor:(JTFormDescriptor *)formDescriptor
{
    return [[[self class] alloc] initWithDescriptor:formDescriptor];
}

- (void)initializeForm
{
    _tableNode            = [[ASTableNode alloc] initWithStyle:UITableViewStyleGrouped];
    _tableNode.dataSource = self;
    _tableNode.delegate   = self;
    [self addSubnode:_tableNode];
}

- (void)dealloc
{
    _tableNode.delegate = nil;
    _tableNode.dataSource = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.window.backgroundColor) {
        self.window.backgroundColor = [UIColor whiteColor];
    }
    self.tableNode.frame = self.bounds;
}

#pragma mark - ASCommonTableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JTSectionDescriptor *sectionDescriptor = [self.formDescriptor sectionAtIndex:section];
    if (sectionDescriptor.headerView)              return sectionDescriptor.headerView;
    if (!sectionDescriptor.headerAttributedString) return nil;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, sectionDescriptor.headerHeight)];
    header.opaque = YES;
    
    ASDisplayNode *contentNode = [[ASDisplayNode alloc] init];
    contentNode.frame = header.bounds;
    [header addSubnode:contentNode];
    
    ASTextNode *textNode = [[ASTextNode alloc] init];
    textNode.attributedText = sectionDescriptor.headerAttributedString;
    [contentNode addSubnode:textNode];
    [contentNode setLayoutSpecBlock:^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
        ASStackLayoutSpec *layoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                spacing:0
                                                                         justifyContent:ASStackLayoutJustifyContentStart
                                                                             alignItems:ASStackLayoutAlignItemsEnd
                                                                               children:@[textNode]];
        return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 15., 3., 15.) child:layoutSpec];
    }];
    return header;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    JTSectionDescriptor *sectionDescriptor = [self.formDescriptor sectionAtIndex:section];
    if (sectionDescriptor.footerView)               return sectionDescriptor.footerView;
    if (!sectionDescriptor.footerAttributedString)  return nil;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, sectionDescriptor.footerHeight)];
    footer.opaque = YES;
    
    ASDisplayNode *contentNode = [[ASDisplayNode alloc] init];
    contentNode.frame = footer.bounds;
    [footer addSubnode:contentNode];
    
    ASTextNode *textNode = [[ASTextNode alloc] init];
    textNode.attributedText = sectionDescriptor.headerAttributedString;
    [contentNode addSubnode:textNode];
    [contentNode setLayoutSpecBlock:^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
        ASStackLayoutSpec *layoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                spacing:0
                                                                         justifyContent:ASStackLayoutJustifyContentStart
                                                                             alignItems:ASStackLayoutAlignItemsEnd
                                                                               children:@[textNode]];
        return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(3., 15., 0., 15.) child:layoutSpec];
    }];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    JTSectionDescriptor *sectionDescriptor = [self.formDescriptor sectionAtIndex:section];
    return sectionDescriptor.headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    JTSectionDescriptor *sectionDescriptor = [self.formDescriptor sectionAtIndex:section];
    return sectionDescriptor.footerHeight;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTSectionDescriptor *section = [self.formDescriptor sectionAtIndex:indexPath.section];
    if (section.sectionOptions & JTFormSectionOptionCanDelete) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle editStyle = [self tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    if (editStyle == UITableViewCellEditingStyleNone) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle != UITableViewCellEditingStyleDelete) return;
    
    // 删除行
    [self.tableView endEditing:YES];
    [self removeRowAtIndexPath:indexPath];

    if ([self.delegate respondsToSelector:@selector(form:commitEditingStyle:forRowAtIndexPath:)]) {
        [self.delegate form:self commitEditingStyle:JTFormCellEditingStyleDelete forRowAtIndexPath:indexPath];
    }
}

#pragma mark - notification

- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentSizeCategoryChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
}

- (void)contentSizeCategoryChanged:(NSNotification *)notification
{
    [self updateAllRows];
}

#pragma mark - JTFormDescriptorDelegate

- (void)formSectionsHaveBeenRemovedAtIndexes:(NSIndexSet *)indexSet
{
    [self.tableNode deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

- (void)formSectionsHaveBeenAddedAtIndexes:(NSIndexSet *)indexSet
{
    [self.tableNode insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

- (void)formRowHasBeenAddedAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableNode insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)formRowHasBeenRemovedAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableNode deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)formRowDescriptorValueHasChanged:(JTRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue
{
    if (self.delegate) {
        [self.delegate form:self rowValueHasChanged:formRow oldValue:oldValue newValue:newValue];
    }
}

#pragma mark - ASTableDataSource

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section
{
    JTSectionDescriptor *sectionDescriptor = self.formDescriptor.formSections[section];
    return sectionDescriptor.formRows.count;
}

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode
{
    return self.formDescriptor.formSections.count;
}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTRowDescriptor *rowDescriptor = [self.formDescriptor rowAtIndexPath:indexPath];
    JTBaseCell *cell = [rowDescriptor cellInForm];
    [rowDescriptor updateUI];
    
    return cell;
}

#pragma mark - ASTableDelegate

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTRowDescriptor *rowDescriptor = [self.formDescriptor rowAtIndexPath:indexPath];
    if (rowDescriptor.disabled) return;
    
    JTBaseCell *cellNode = [rowDescriptor cellInForm];
    if (!([cellNode cellCanBecomeFirstResponder] && [cellNode cellBecomeFirstResponder])) {}
    if ([cellNode respondsToSelector:@selector(formCellDidSelected)]) {
        [cellNode formCellDidSelected];
    }
}

- (ASSizeRange)tableNode:(ASTableNode *)tableNode constrainedSizeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTRowDescriptor *row = [self.formDescriptor rowAtIndexPath:indexPath];
    if (row.height == JTFormUnspecifiedCellHeight || row.height <= 0) {
        return ASSizeRangeUnconstrained;
    } else {
        return ASSizeRangeMake(CGSizeMake(0, row.height));
    }
}

- (void)tableNode:(ASTableNode *)tableNode willBeginBatchFetchWithContext:(ASBatchContext *)context
{
    if (!self.delegate) return;
    
    if ([self.delegate respondsToSelector:@selector(tailLoadWithContent:)]) {
        [context beginBatchFetching];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate tailLoadWithContent:context];
        });
    }
}

#pragma mark - row type

+ (NSMutableDictionary *)cellClassesForRowTypes
{
    static NSMutableDictionary * _cellClassesForRowTypes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cellClassesForRowTypes = @{
                                    JTFormRowTypeText               : [JTFormTextFieldCell class],
                                    JTFormRowTypeName               : [JTFormTextFieldCell class],
                                    JTFormRowTypeEmail              : [JTFormTextFieldCell class],
                                    JTFormRowTypeNumber             : [JTFormTextFieldCell class],
                                    JTFormRowTypeInteger            : [JTFormTextFieldCell class],
                                    JTFormRowTypeDecimal            : [JTFormTextFieldCell class],
                                    JTFormRowTypePassword           : [JTFormTextFieldCell class],
                                    JTFormRowTypePhone              : [JTFormTextFieldCell class],
                                    JTFormRowTypeURL                : [JTFormTextFieldCell class],
                                    JTFormRowTypeTextView           : [JTFormTextViewCell class],
                                    JTFormRowTypeInfo               : [JTFormTextViewCell class],
                                    JTFormRowTypePushSelect         : [JTFormSelectCell class],
                                    JTFormRowTypeMultipleSelect     : [JTFormSelectCell class],
                                    JTFormRowTypeSheetSelect        : [JTFormSelectCell class],
                                    JTFormRowTypeAlertSelect        : [JTFormSelectCell class],
                                    JTFormRowTypePickerSelect       : [JTFormSelectCell class],
                                    JTFormRowTypePushButton         : [JTFormSelectCell class],
                                    JTFormRowTypeDate               : [JTFormDateCell class],
                                    JTFormRowTypeTime               : [JTFormDateCell class],
                                    JTFormRowTypeDateTime           : [JTFormDateCell class],
                                    JTFormRowTypeCountDownTimer     : [JTFormDateCell class],
                                    JTFormRowTypeDateInline         : [JTFormDateInlineCell class],
                                    JTFormRowTypeSwitch             : [JTFromSwitchCell class],
                                    JTFormRowTypeCheck              : [JTFormCheckCell class],
                                    JTFormRowTypeStepCounter        : [JTFormStepCounterCell class],
                                    JTFormRowTypeSegmentedControl   : [JTFormSegmentCell class],
                                    JTFormRowTypeSlider             : [JTFormSliderCell class],
                                    JTFormRowTypeFloatText          : [JTFormFloatTextCell class]
                                    }.mutableCopy;
    });
    return _cellClassesForRowTypes;
}

#pragma mark - inline row type

+ (NSMutableDictionary *)inlineRowTypesForRowTypes
{
    static NSMutableDictionary *_inlineRowTypesForRowTypes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 映射关系：row type -> 被关联的 rowType
        _inlineRowTypesForRowTypes = [NSMutableDictionary dictionary];
    });
    return _inlineRowTypesForRowTypes;
}

- (void)ensureRowIsVisible:(JTRowDescriptor *)rowDescriptor
{
    JTBaseCell *inlineCell = [rowDescriptor cellInForm];
    if (inlineCell.isVisible) return;
    
    NSIndexPath *indexPath = [self.formDescriptor indexPathForRowDescriptor:rowDescriptor];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableNode scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    });
}

#pragma mark - edit text delegate

- (BOOL)textTypeRowShouldBeginEditing:(JTRowDescriptor *)row
                            textField:(nullable UITextField *)textField
                     editableTextNode:(nullable ASEditableTextNode *)editableTextNode
{
    return !row.disabled;
}

- (void)textTypeRowDidBeginEditing:(JTRowDescriptor *)row
                         textField:(nullable UITextField *)textField
                  editableTextNode:(nullable ASEditableTextNode *)editableTextNode
{
    NSString *editText = [row editTextValue];
    textField.text = editText;
    editableTextNode.textView.text = editText;
    
    [self beginEditing:row];
}

- (BOOL)textTypeRowShouldChangeTextInRange:(NSRange)range
                           replacementText:(NSString *)text
                             rowDescriptor:(JTRowDescriptor *)row
                                 textField:(nullable UITextField *)textField
                          editableTextNode:(nullable ASEditableTextNode *)editableTextNode
{
    if (row.maxNumberOfCharacters) {
        NSString *existString = textField ? textField.text : editableTextNode.textView.text;
        NSString *newString = [existString stringByReplacingCharactersInRange:range withString:text];
        if (newString.length > row.maxNumberOfCharacters.integerValue) {
            return NO;
        }
    }
    return YES;
}

- (void)textTypeRowDidEndEditing:(JTRowDescriptor *)row
                       textField:(nullable UITextField *)textField
                editableTextNode:(nullable ASEditableTextNode *)editableTextNode
{
    NSString *text = textField ? textField.text : editableTextNode.textView.text;
    
    if (text.length > 0) {
        NSString *rowType = row.rowType;
        if ([rowType isEqualToString:JTFormRowTypeNumber] ||
            [rowType isEqualToString:JTFormRowTypeDecimal])
        {
            // 浮点数
            row.value = [NSDecimalNumber decimalNumberWithString:text locale:NSLocale.currentLocale];
        }
        else
        {
            row.value = text;
        }
    } else {
        row.value = nil;
    }
    NSString *displayText = [row displayTextValue];
    textField.text = displayText;
    editableTextNode.textView.text = displayText;

    [self endEditing:row];
}

- (void)beginEditing:(JTRowDescriptor *)row
{
    [[row cellInForm] cellHighLight];
}

- (void)endEditing:(JTRowDescriptor *)row
{
    [[row cellInForm] cellUnHighLight];
}

#pragma mark - get data

- (NSDictionary *)formValues
{
    NSMutableDictionary *result = @{}.mutableCopy;
    for (JTSectionDescriptor *section in self.formDescriptor.allSections) {
        for (JTRowDescriptor *row in section.allRows) {
            if (row.tag) {
                [result setObject:row.value ? row.value : [NSNull null] forKey:row.tag];
            }
        }
    }
    return result.copy;
}

- (NSDictionary *)formHttpValues
{
    NSMutableDictionary *result = @{}.mutableCopy;
    for (JTSectionDescriptor *section in self.formDescriptor.allSections) {
        for (JTRowDescriptor *row in section.allRows) {
            if (row.tag) {
                id rowValue = [row.value cellValue];
                [result setObject:rowValue ? rowValue : [NSNull null] forKey:row.tag];
            }
        }
    }
    return result.copy;
}

- (NSArray<NSError *> *)sectionValidationErrors:(JTSectionDescriptor *)sectionDescriptor
{
    NSMutableArray *result = @[].mutableCopy;
    
    for (JTRowDescriptor *row in sectionDescriptor.formRows) {
        JTFormValidateObject *vObject = [row doValidate];
        if (vObject && !vObject.valid) {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey : vObject.errorMsg
                                       };
            NSError *error = [[NSError alloc] initWithDomain:JTFormErrorDomain code:JTFormErrorCodeInvalid userInfo:userInfo];
            [result addObject:error];
        }
    }
    return [result copy];
}

- (NSArray<NSError *> *)formValidationErrors
{
    NSMutableArray *result = @[].mutableCopy;
    
    for (JTSectionDescriptor *section in self.formDescriptor.formSections) {
        for (JTRowDescriptor *row in section.formRows) {
            JTFormValidateObject *vObject = [row doValidate];
            if (vObject && !vObject.valid) {
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey : vObject.errorMsg
                                           };
                NSError *error = [[NSError alloc] initWithDomain:JTFormErrorDomain code:JTFormErrorCodeInvalid userInfo:userInfo];
                [result addObject:error];
            }
        }
    }
    return [result copy];
}

- (void)showFormValidationError:(NSError *)error
{
    if (!error || !self.tableNode.closestViewController) return;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString jt_localizedStringForKey:@"error"]
                                                                             message:error.localizedDescription
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:[NSString jt_localizedStringForKey:@"ok"] style:UIAlertActionStyleDefault handler:nil]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableNode.closestViewController presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)showFormValidationError:(NSError *)error withTitle:(NSString*)title
{
    if (!error || !self.tableNode.closestViewController) return;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:error.localizedDescription
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:[NSString jt_localizedStringForKey:@"ok"] style:UIAlertActionStyleDefault handler:nil]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableNode.closestViewController presentViewController:alertController animated:YES completion:nil];
    });
}

#pragma mark - row

- (void)addRow:(JTRowDescriptor *)formRow afterRow:(JTRowDescriptor *)afterRow
{
    if (afterRow.sectionDescriptor && [self.formDescriptor.formSections containsObject:afterRow.sectionDescriptor]){
        [afterRow.sectionDescriptor addRow:formRow afterRow:afterRow];
    } else{
        [[self.formDescriptor.formSections lastObject] addRow:formRow];
    }
}

-(void)addRow:(JTRowDescriptor *)formRow beforeRow:(JTRowDescriptor *)beforeRow
{
    if (beforeRow.sectionDescriptor && [self.formDescriptor.formSections containsObject:beforeRow.sectionDescriptor]){
        [beforeRow.sectionDescriptor addRow:formRow beforeRow:beforeRow];
    } else{
        [[self.formDescriptor.formSections lastObject] addRow:formRow];
    }
}

- (void)addRow:(JTRowDescriptor *)formRow afterRowWithTag:(NSString *)afterRowTag
{
    JTRowDescriptor *afterRow = [self.formDescriptor formRowWithTag:afterRowTag];
    [self addRow:formRow afterRow:afterRow];
}

- (void)addRow:(JTRowDescriptor *)formRow beforeRowWithTag:(NSString *)beforeRowTag
{
    JTRowDescriptor *beforeRow = [self.formDescriptor formRowWithTag:beforeRowTag];
    [self addRow:formRow beforeRow:beforeRow];
}

- (void)addRow:(JTRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >=0 &&
        indexPath.section >= 0 &&
        indexPath.section < self.formDescriptor.formSections.count)
    {
        JTSectionDescriptor *section = self.formDescriptor.formSections[indexPath.section];
        [section addRow:formRow atIndex:indexPath.row];
    }
}

- (void)addRow:(JTRowDescriptor *)formRow
{
    JTSectionDescriptor *section = [self.formDescriptor.formSections lastObject];
    [section addRow:formRow];
}

-(void)removeRow:(JTRowDescriptor *)row
{
    if ([self.formDescriptor.formSections containsObject:row.sectionDescriptor]) {
        [row.sectionDescriptor removeRow:row];
    }
}

- (void)removeRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >=0 &&
        indexPath.section >= 0 &&
        indexPath.section < self.formDescriptor.formSections.count)
    {
        JTSectionDescriptor *section = self.formDescriptor.formSections[indexPath.section];
        [section removeRowAtIndex:indexPath.row];
    }
}

-(void)removeRowByTag:(NSString *)tag
{
    JTRowDescriptor *row = [self.formDescriptor formRowWithTag:tag];
    [self removeRow:row];
}

- (nullable JTRowDescriptor *)findRowByTag:(NSString *)tag
{
    JTRowDescriptor *row = [self.formDescriptor formRowWithTag:tag];
    return row;
}

- (JTRowDescriptor *)rowAtIndexPath:(NSIndexPath *)indexPath
{
    JTRowDescriptor *row = [self.formDescriptor rowAtIndexPath:indexPath];
    return row;
}

- (nullable id)findRowValueByTag:(NSString *)tag
{
    JTRowDescriptor *row = [self.formDescriptor formRowWithTag:tag];
    return [row.value cellValue];
}

- (nullable NSIndexPath *)indexPathForRow:(JTRowDescriptor *)rowDescriptor
{
    return [self.formDescriptor indexPathForRowDescriptor:rowDescriptor];
}

- (void)setRowsHidden:(BOOL)hidden byTags:(NSArray<NSString *> *)tags
{
    [tags enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JTRowDescriptor *row = [self.formDescriptor formRowWithTag:obj];
        row.hidden = hidden;
    }];
}

- (void)setRowsDisabled:(BOOL)disabled byTags:(NSArray<NSString *> *)tags
{
    [tags enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JTRowDescriptor *row = [self.formDescriptor formRowWithTag:obj];
        row.disabled = disabled;
    }];
}

- (void)setRowsRequired:(BOOL)required byTags:(NSArray<NSString *> *)tags
{
    [tags enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JTRowDescriptor *row = [self.formDescriptor formRowWithTag:obj];
        if (!row) return;

        row.required = required;
        [row updateUI];
    }];
}

- (void)setRowValue:(nullable id)value byTag:(NSString *)tag
{
    JTRowDescriptor *row = [self.formDescriptor formRowWithTag:tag];
    row.value = value;
    [row updateUI];
}

- (void)updateRowsByTags:(NSArray<NSString *> *)tags
{
    [tags enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JTRowDescriptor *row = [self.formDescriptor formRowWithTag:obj];
        [row updateUI];
    }];
}

- (void)updateRow:(JTRowDescriptor *)rowDescriptor
{
    [rowDescriptor updateUI];
}

- (void)updateAllRows
{
    for (JTSectionDescriptor *section in self.formDescriptor.formSections) {
        for (JTRowDescriptor *row in section.formRows) {
            [row updateUI];
        }
    }
}

- (void)reloadRows:(NSArray <JTRowDescriptor *>*)rowDescriptors
{
    NSMutableArray *array = [NSMutableArray array];
    for (JTRowDescriptor *row in rowDescriptors) {
        NSIndexPath *indexPath = [self.formDescriptor indexPathForRowDescriptor:row];
        [array addObject:indexPath];
    }
    if (array.count != 0) {
        [self.tableNode reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)reloadForm
{
    [self.tableNode reloadData];
}

#pragma mark - section

- (void)addSection:(JTSectionDescriptor *)section
{
    [self.formDescriptor addSection:section];
}

- (void)addSection:(JTSectionDescriptor *)section atIndex:(NSInteger)index
{
    [self.formDescriptor addSection:section atIndex:index];
}

- (void)addSection:(JTSectionDescriptor *)section afterSection:(JTSectionDescriptor *)afterSection
{
    [self.formDescriptor addSection:section afterSection:afterSection];
}

- (void)addSection:(JTSectionDescriptor *)section beforeSection:(JTSectionDescriptor *)beforeSection
{
    [self.formDescriptor addSection:section beforeSection:beforeSection];
}

- (void)removeSection:(JTSectionDescriptor *)section
{
    [self.formDescriptor removeSection:section];
}

- (void)removeSectionAtIndex:(NSUInteger)index
{
    [self.formDescriptor removeSectionAtIndex:index];
}

- (void)removeSectionsAtIndexes:(NSIndexSet *)indexes
{
    [self.formDescriptor removeSectionsAtIndexes:indexes];
}

- (nullable JTSectionDescriptor *)sectionAtIndex:(NSUInteger)index
{
    if (index<0 || index>=self.formDescriptor.formSections.count) return nil;
    return self.formDescriptor.formSections[index];
}

- (NSUInteger)indexForSection:(JTSectionDescriptor *)sectionDescriptor
{
    return [self.formDescriptor.formSections indexOfObject:sectionDescriptor];
}

#pragma mark - helper

- (ASTableView *)tableView
{
    return self.tableNode.view;
}

@end
