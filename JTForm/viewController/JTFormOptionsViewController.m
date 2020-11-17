//
//  JTFormOptionsViewController.m
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//

#import "JTFormOptionsViewController.h"
#import "JTForm.h"

@interface JTFormOptionsViewController () <ASTableDelegate, ASTableDataSource>
@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, strong) NSMutableArray<JTOptionObject *> *selectedItems;
@end


@implementation JTFormOptionsViewController
@synthesize rowDescriptor = _rowDescriptor;
@synthesize form = _form;

- (instancetype)init
{
    _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStyleGrouped];
    if (self = [super initWithNode:_tableNode]) {
        _tableNode.delegate        = self;
        _tableNode.dataSource      = self;
        _tableNode.backgroundColor = UIColorHex(f0f0f0);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
#ifdef DEBUG
    _tableNode.accessibilityIdentifier = @"tableview";
    _tableNode.accessibilityLabel = @"tableview";
    _tableNode.view.accessibilityIdentifier = @"tableview";
#endif
    
    _selectedItems = [self.rowDescriptor.rowType isEqualToString:JTFormRowTypePushSelect] ?
                     (self.rowDescriptor.value ? @[self.rowDescriptor.value].mutableCopy : [NSMutableArray array]) :
                     (self.rowDescriptor.value ? [self.rowDescriptor.value mutableCopy] : [NSMutableArray array]);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeMultipleSelect]) {
        // 多选类型时，selectedItems 中有的 items 可能在 selectorOptions 不存在，
        // 需要将这些值找出来并从 selectedItems 中删除
        NSMutableIndexSet *unExistSet = [NSMutableIndexSet indexSet];
        for (NSInteger i = 0; i < _selectedItems.count; i++) {
            JTOptionObject *selectOption = _selectedItems[i];
            BOOL exist = false;
            for (JTOptionObject *option in self.rowDescriptor.selectorOptions) {
                if ([option jt_isEqual:selectOption]) {
                    exist = YES;
                    break;
                }
            }
            if (!exist) {
                [unExistSet addIndex:i];
            }
        }
        [_selectedItems removeObjectsAtIndexes:unExistSet];
        [self.rowDescriptor manualSetValue:[_selectedItems copy]];
    }
    [self.form updateRow:self.rowDescriptor];
}

#pragma mark - ASTableDataSource methods

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode
{
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section
{
    return [self.rowDescriptor.selectorOptions count];
}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTOptionObject *option   = self.rowDescriptor.selectorOptions[indexPath.row];
    ASTextCellNode *cellNode = [[ASTextCellNode alloc] init];
    cellNode.backgroundColor = UIColor.whiteColor;
    cellNode.accessoryType   = [self selectedItemsContainOption:option index:nil] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cellNode.separatorInset  = UIEdgeInsetsMake(0, 15, 0, 0);
    cellNode.textNode.attributedText = [NSAttributedString jt_attributedStringWithString:[option descriptionForForm]
                                                                                    font:[UIFont systemFontOfSize:16.]
                                                                                   color:UIColorHex(333333)
                                                                          firstWordColor:nil];
    return cellNode;
}

#pragma mark - ASTableDelegate methods

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableNode cellForRowAtIndexPath:indexPath];
    JTOptionObject *optionObject = self.rowDescriptor.selectorOptions[indexPath.row];
    
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeMultipleSelect]) {
        NSUInteger index;
        if ([self selectedItemsContainOption:optionObject index:&index]) {
            // 之前已被选中，再次点击后取消选中
            [_selectedItems removeObjectAtIndex:index];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            // 之前未被选中，点击后被选中
            [_selectedItems addObject:optionObject];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else {
        if ([self.rowDescriptor.value jt_isEqual:optionObject]) {
            [self.rowDescriptor manualSetValue:nil];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else {
            if (self.rowDescriptor.value) {
                NSInteger index = NSNotFound;
                for (JTOptionObject *selectObject in self.rowDescriptor.selectorOptions) {
                    if ([selectObject jt_isEqual:self.rowDescriptor.value]) {
                        index = [self.rowDescriptor.selectorOptions indexOfObject:selectObject];
                        break;
                    }
                }
                if (index != NSNotFound) {
                    NSIndexPath *oldSelectIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
                    ASTextCellNode *oldCellNode = [tableNode nodeForRowAtIndexPath:oldSelectIndexPath];
                    oldCellNode.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            [self.rowDescriptor manualSetValue:optionObject];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        // 有值的话返回
        if (self.rowDescriptor.value && self.modalPresentationStyle == UIModalPresentationPopover) {
            [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        } else if (self.rowDescriptor.value && [self.parentViewController isKindOfClass:[UINavigationController class]]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    [tableNode deselectRowAtIndexPath:indexPath animated:YES];
}

- (ASSizeRange)tableNode:(ASTableNode *)tableNode constrainedSizeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ASSizeRangeMake(CGSizeMake(0, 55.));
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.;
}

#pragma mark - helper

- (BOOL)selectedItemsContainOption:(JTOptionObject *)optionObject index:(NSUInteger *)index
{
    if (![optionObject isKindOfClass:[JTOptionObject class]]) return false;
    
    for (NSInteger i = 0; i < _selectedItems.count; i++) {
        JTOptionObject *selectObject = _selectedItems[i];        
        if ([optionObject jt_isEqual:selectObject]) {
            if (index) *index = i;
            return true;
        }
    }
    return false;
}
@end
