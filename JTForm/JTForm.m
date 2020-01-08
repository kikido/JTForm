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
#import "JTCollectionLayoutDelegate.h"


typedef NS_ENUM(NSInteger, JTFormErrorCode) {
    JTFormErrorCodeInvalid = -999,
    JTFormErrorCodeRequired = -1000
};

NSString *const JTFormErrorDomain = @"JTFormErrorDomain";

@interface JTFormDescriptor ()
@property (nonatomic, weak) JTCollectionLayoutInfo *collectionInfo;
@end

@interface JTForm () <ASTableDelegate, ASTableDataSource, JTFormDescriptorDelegate, ASCollectionDataSource, ASCollectionDelegate, ASCollectionViewLayoutInspecting>
@end

@implementation JTForm {
    JTFormType _formType;
    
    struct {
        unsigned int impFormRowValueHasChangedOldValueNewValue:1;
        unsigned int impFormCommitEditingStyleForRowAtIndexPath:1;
        unsigned int impTailLoadWithContent:1;
    } _delegateFlags;
    
    
}

- (instancetype)initWithDescriptor:(JTFormDescriptor *)formDescriptor
{
    return [[[self class] alloc] initWithDescriptor:formDescriptor formType:JTFormTypeTable];
}

+ (instancetype)formWithDescriptor:(JTFormDescriptor *)formDescriptor
{
    return [[self alloc] initWithDescriptor:formDescriptor formType:JTFormTypeTable];
}

+ (instancetype)formWithDescriptor:(JTFormDescriptor *)formDescriptor formType:(JTFormType)formType
{
    return [[self alloc] initWithDescriptor:formDescriptor formType:formType];
}

- (instancetype)initWithDescriptor:(JTFormDescriptor *)formDescriptor formType:(JTFormType)formType
{
    if (self = [super initWithFrame:CGRectZero]) {
        _formDescriptor      = formDescriptor;
        _formDescriptor.form = self;
        _formType            = formType;
        
        [self initializeForm];
        [self addNotifications];
    }
    return self;
}

- (void)initializeForm
{
    if (_formType == JTFormTypeTable) {
        _tableNode            = [[ASTableNode alloc] initWithStyle:UITableViewStyleGrouped];
        _tableNode.dataSource = self;
        _tableNode.delegate   = self;
        [self addSubnode:_tableNode];
    } else {
        JTCollectionLayoutDelegate *layoutDelegate = [self _layoutDelegateForCollectionNode:nil];
        _collectionNode = [[ASCollectionNode alloc] initWithLayoutDelegate:layoutDelegate layoutFacilitator:nil];
        _collectionNode.dataSource = self;
        _collectionNode.delegate = self;
        _collectionNode.layoutInspector = self;
        [_collectionNode registerSupplementaryNodeOfKind:UICollectionElementKindSectionHeader];
        [_collectionNode registerSupplementaryNodeOfKind:UICollectionElementKindSectionFooter];
        [self addSubnode:_collectionNode];
    }
}

- (void)dealloc
{
    _tableNode.delegate = nil;
    _tableNode.dataSource = nil;
    _collectionNode.delegate = nil;
    _collectionNode.dataSource = nil;
    _collectionNode.layoutInspector = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.window.backgroundColor) {
        self.window.backgroundColor = [UIColor whiteColor];
    }
    if (_formType == JTFormTypeTable) {
        _tableNode.frame = self.bounds;
    } else {
        _collectionNode.frame = self.bounds;
    }
}

#pragma mark - setter

- (void)setDelegate:(id<JTFormDelegate>)delegate
{
    ASDisplayNodeAssertMainThread();
    if (delegate == nil) {
        _delegate = nil;
//        _delegateFlags = {}; 为什么不能这么写。。。
        _delegateFlags.impFormRowValueHasChangedOldValueNewValue = 0;
        _delegateFlags.impFormCommitEditingStyleForRowAtIndexPath = 0;
        _delegateFlags.impTailLoadWithContent = 0;
    } else {
        _delegate = delegate;
        _delegateFlags.impFormRowValueHasChangedOldValueNewValue = [delegate respondsToSelector:@selector(form:rowValueHasChanged:oldValue:newValue:)];
        _delegateFlags.impFormCommitEditingStyleForRowAtIndexPath = [delegate respondsToSelector:@selector(form:commitEditingStyle:forRowAtIndexPath:)];
        _delegateFlags.impTailLoadWithContent = [delegate respondsToSelector:@selector(tailLoadWithContent:)];
    }
}

#pragma mark - getter

- (ASTableView *)tableView
{
    return self.tableNode.view;
}

- (ASCollectionView *)collectionView
{
    return self.collectionNode.view;
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
        textNode.style.width = ASDimensionMake(constrainedSize.min.width - 30.);
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
        textNode.style.width = ASDimensionMake(constrainedSize.min.width - 30.);
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

    if (_delegateFlags.impFormCommitEditingStyleForRowAtIndexPath) {
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
    if (_formType == JTFormTypeTable) {
        [self updateAllRows];
    } else {
        [self.collectionNode reloadData];
    }
}

#pragma mark - JTFormDescriptorDelegate

- (void)formSectionsHaveBeenRemovedAtIndexes:(NSIndexSet *)indexSet
{
    ASDisplayNodeAssertMainThread();
    if (_formType == JTFormTypeTable) {
        [self.tableNode deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    } else {
        _resetHeaderAndFooterHeights(self.formDescriptor.collectionInfo, _formDescriptor);
        [self.collectionNode deleteSections:indexSet];
    }
}

- (void)formSectionsHaveBeenAddedAtIndexes:(NSIndexSet *)indexSet
{
    ASDisplayNodeAssertMainThread();
    if (_formType == JTFormTypeTable) {
        [self.tableNode insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    } else {
        _resetHeaderAndFooterHeights(self.formDescriptor.collectionInfo, _formDescriptor);
        [self.collectionNode insertSections:indexSet];
    }
}

- (void)formRowHasBeenAddedAtIndexPath:(NSIndexPath *)indexPath
{
    ASDisplayNodeAssertMainThread();
    if (_formType == JTFormTypeTable) {
        [self.tableNode insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.collectionNode insertItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)formRowHasBeenRemovedAtIndexPath:(NSIndexPath *)indexPath
{
    ASDisplayNodeAssertMainThread();
    if (_formType == JTFormTypeTable) {
        [self.tableNode deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.collectionNode deleteItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)formRowDescriptorValueHasChanged:(JTRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue
{
    if (_delegateFlags.impFormRowValueHasChangedOldValueNewValue) {
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

//- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    JTRowDescriptor *rowDescriptor = [self.formDescriptor rowAtIndexPath:indexPath];
//    JTBaseCell *cell = [rowDescriptor cellInForm];
//    [rowDescriptor updateUI];
//
//    return cell;
//}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTRowDescriptor *rowDescriptor = [self.formDescriptor rowAtIndexPath:indexPath];
    return ^{
        JTBaseCell *cell = [rowDescriptor cellInForm];
        if (!cell.nodeLoaded) {
            [cell onDidLoad:^(__kindof ASDisplayNode * _Nonnull node) {
                [rowDescriptor updateUI];
            }];
        }
        return cell;
    };
}

#pragma mark - ASTableDelegate

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTRowDescriptor *rowDescriptor = [self.formDescriptor rowAtIndexPath:indexPath];
    if (rowDescriptor.disabled) return;
    
    JTBaseCell *cellNode = [rowDescriptor cellInForm];
    if ([cellNode cellCanBecomeFirstResponder] && [cellNode cellBecomeFirstResponder]) {}
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
    if (_delegateFlags.impTailLoadWithContent) {
        [context beginBatchFetching];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate tailLoadWithContent:context];
        });
    }
}

- (void)collectionNode:(ASCollectionNode *)collectionNode willBeginBatchFetchWithContext:(ASBatchContext *)context
{
    if (_delegateFlags.impTailLoadWithContent) {
        [context beginBatchFetching];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate tailLoadWithContent:context];
        });
    }
}

#pragma mark - ASCollectionDataSource

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section
{
    JTSectionDescriptor *sectionDescriptor = self.formDescriptor.formSections[section];
    return sectionDescriptor.formRows.count;
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode
{
    return [self.formDescriptor.formSections count];
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JTRowDescriptor *rowDescriptor = [self.formDescriptor rowAtIndexPath:indexPath];
    return ^{
        JTBaseCell *cell = [rowDescriptor cellInForm];
        if (!cell.nodeLoaded) {
            [cell onDidLoad:^(__kindof ASDisplayNode * _Nonnull node) {
                [rowDescriptor updateUI];
            }];
        }
        return cell;
    };
}

//- (ASCellNode *)collectionNode:(ASCollectionNode *)collectionNode nodeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    JTRowDescriptor *rowDescriptor = [self.formDescriptor rowAtIndexPath:indexPath];
//    JTBaseCell *cell = [rowDescriptor cellInForm];
//    [rowDescriptor updateUI];
//    return cell;
//}

- (ASCellNode *)collectionNode:(ASCollectionNode *)collectionNode nodeForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BOOL isheader = [kind isEqualToString:UICollectionElementKindSectionHeader];
    JTSectionDescriptor *sectionDescriptor = self.formDescriptor.formSections[indexPath.section];

    if (isheader && sectionDescriptor.headerView){
        ASCellNode *node = [[ASCellNode alloc] initWithViewBlock:^UIView * _Nonnull{
            return sectionDescriptor.headerView;
        }];
        return node;
    } else if (!isheader && sectionDescriptor.footerView) {
        ASCellNode *node = [[ASCellNode alloc] initWithViewBlock:^UIView * _Nonnull{
            return sectionDescriptor.footerView;
        }];
        return node;
    }
    if ((isheader && !sectionDescriptor.headerAttributedString) || (!isheader && !sectionDescriptor.footerAttributedString)) {
        return nil;
    }
    // 也可以调整 JTFormDescriptor 的属性 sectionInsets
    UIEdgeInsets textInsets = UIEdgeInsetsZero;
    if (self.formDescriptor.scrollDirection == JTFormScrollDirectionVertical) {
        if (isheader) {
            textInsets = UIEdgeInsetsMake(INFINITY, 15., 3., 15.);
        } else {
            textInsets = UIEdgeInsetsMake(3., 15., INFINITY, 15.);
        }
    } else {
       if (isheader) {
            textInsets = UIEdgeInsetsMake(3., 3., INFINITY, 3.);
        } else {
            textInsets = UIEdgeInsetsMake(3., 3., INFINITY, 3.);
        }
    }
    ASTextCellNode *textCellNode = [[ASTextCellNode alloc] initWithAttributes:@{} insets:textInsets];
    textCellNode.textNode.attributedText = isheader ? sectionDescriptor.headerAttributedString : sectionDescriptor.footerAttributedString;
    textCellNode.backgroundColor = UIColor.yellowColor;
    return textCellNode;
}

#pragma mark - ASCollectionDelegate

// 实际上通过 ASCollectionLayout 的 layoutDelegate 属性来决定 sizerange 以及 directions
// 这个方法不起作用
- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return ASSizeRangeZero;
}

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JTRowDescriptor *rowDescriptor = [self.formDescriptor rowAtIndexPath:indexPath];
    if (rowDescriptor.disabled) return;
    
    JTBaseCell *cellNode = [rowDescriptor cellInForm];
    if ([cellNode cellCanBecomeFirstResponder] && [cellNode cellBecomeFirstResponder]) {}
    if ([cellNode respondsToSelector:@selector(formCellDidSelected)]) {
        [cellNode formCellDidSelected];
    }
}

// 这个方法不起作用，实际上由 ASCollectionLayout 的 layoutDelegate 属性来控制
- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode sizeRangeForHeaderInSection:(NSInteger)section
{
    CGFloat layoutWidth = self.formDescriptor.scrollDirection ==  JTFormScrollDirectionVertical ? self.bounds.size.width : self.bounds.size.height;
    CGFloat layoutHeight = [(JTSectionDescriptor *)self.formDescriptor.formSections[section] headerHeight];

    if (self.formDescriptor.scrollDirection == JTFormScrollDirectionHorizontal) {
        return ASSizeRangeMake(CGSizeMake(layoutHeight, layoutWidth));
    } else {
        return ASSizeRangeMake(CGSizeMake(layoutWidth, layoutHeight));
    }
}

// 这个方法不起作用，实际上由 ASCollectionLayout 的 layoutDelegate 属性来控制
- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode sizeRangeForFooterInSection:(NSInteger)section
{
    CGFloat layoutWidth = self.formDescriptor.scrollDirection ==  JTFormScrollDirectionVertical ? self.bounds.size.width : self.bounds.size.height;
    CGFloat layoutHeight = [(JTSectionDescriptor *)self.formDescriptor.formSections[section] footerHeight];

    if (self.formDescriptor.scrollDirection == JTFormScrollDirectionHorizontal) {
        return ASSizeRangeMake(CGSizeMake(layoutHeight, layoutWidth));
    } else {
        return ASSizeRangeMake(CGSizeMake(layoutWidth, layoutHeight));
    }
}

#pragma mark - ASCollectionViewLayoutInspecting

// 这个方法不起作用，实际上由 ASCollectionLayout 的 layoutDelegate 属性来控制
- (ASScrollDirection)scrollableDirections
{
    return ASScrollDirectionVerticalDirections;
}

// 这个方法不起作用，实际上由 ASCollectionLayout 的 layoutDelegate 属性来控制
- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForNodeAtIndexPath:(NSIndexPath *)indexPath
{
    return [self collectionNode:collectionView.collectionNode constrainedSizeForItemAtIndexPath:indexPath];
}

- (NSUInteger)collectionView:(ASCollectionView *)collectionView supplementaryNodesOfKind:(NSString *)kind inSection:(NSUInteger)section
{
    JTSectionDescriptor *sectionDescriptor = self.formDescriptor.formSections[section];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return (sectionDescriptor.headerAttributedString || sectionDescriptor.headerView) ? 1 : 0;
    } else {
        return (sectionDescriptor.footerAttributedString || sectionDescriptor.footerView) ? 1 : 0;
    }
}

- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForSupplementaryNodeOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CGFloat layoutWidth = self.formDescriptor.scrollDirection ==  JTFormScrollDirectionVertical ? self.bounds.size.width : self.bounds.size.height;
    CGFloat layoutHeight = [(JTSectionDescriptor *)self.formDescriptor.formSections[indexPath.section] footerHeight];

    if (self.formDescriptor.scrollDirection == JTFormScrollDirectionHorizontal) {
        return ASSizeRangeMake(CGSizeMake(layoutHeight, layoutWidth));
    } else {
        return ASSizeRangeMake(CGSizeMake(layoutWidth, layoutHeight));
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

- (nullable JTRowDescriptor *)findRowByTag:(id<NSCopying>)tag
{
    JTRowDescriptor *row = [self.formDescriptor formRowWithTag:tag];
    return row;
}

- (JTRowDescriptor *)rowAtIndexPath:(NSIndexPath *)indexPath
{
    JTRowDescriptor *row = [self.formDescriptor rowAtIndexPath:indexPath];
    return row;
}

- (nullable id)findRowValueByTag:(id<NSCopying>)tag
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

- (JTCollectionLayoutDelegate *)_layoutDelegateForCollectionNode:(ASControlNode *)collectionNode
{
    NSMutableArray *headerHeights = [NSMutableArray array];
    NSMutableArray *footerHeights = [NSMutableArray array];
    for (NSInteger i = 0; i < _formDescriptor.formSections.count; i++) {
        [headerHeights addObject:@(((JTSectionDescriptor *)_formDescriptor.formSections[i]).headerHeight)];
        [footerHeights addObject:@(((JTSectionDescriptor *)_formDescriptor.formSections[i]).footerHeight)];
    }
    JTCollectionLayoutInfo *info = [[JTCollectionLayoutInfo alloc] initWithNumberOfColumn:self.formDescriptor.numberOfColumn
                                                                            headerHeights:headerHeights
                                                                            footerHeights:footerHeights
                                                                              columnSpace:self.formDescriptor.interItemSpace
                                                                                lineSpace:self.formDescriptor.lineSpace
                                                                                 itemSize:self.formDescriptor.itmeSize
                                                                            sectionInsets:self.formDescriptor.sectionInsets
                                                                                     type:_formType
                                                                          scrollDirection:self.formDescriptor.scrollDirection];
    self.formDescriptor.collectionInfo = info;
    return [[JTCollectionLayoutDelegate alloc] initWithInfo:info];
}

static inline void _resetHeaderAndFooterHeights(JTCollectionLayoutInfo *info, JTFormDescriptor *formDescriptor) {
    if (!info || !formDescriptor) return;
    
    NSMutableArray *headerHeights = [NSMutableArray array];
    NSMutableArray *footerHeights = [NSMutableArray array];
    for (NSInteger i = 0; i < formDescriptor.formSections.count; i++) {
        [headerHeights addObject:@(((JTSectionDescriptor *)formDescriptor.formSections[i]).headerHeight)];
        [footerHeights addObject:@(((JTSectionDescriptor *)formDescriptor.formSections[i]).footerHeight)];
    }
    info.headerHeights = headerHeights;
    info.footerHeights = footerHeights;
}

@end
