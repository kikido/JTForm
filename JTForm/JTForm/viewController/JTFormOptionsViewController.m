//
//  JTFormOptionsViewController.m
//  JTForm
//
//  Created by dqh on 2019/4/23.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTFormOptionsViewController.h"
#import "JTOptionObject.h"

@interface JTFormOptionsViewController () <ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, copy  ) NSString    *headerTitle;
@property (nonatomic, copy  ) NSString    *footerTitle;

@property (nonatomic, strong) NSMutableArray<JTOptionObject *> *selectedItems;

@end

@implementation JTFormOptionsViewController

@synthesize rowDescriptor = _rowDescriptor;
@synthesize form = _form;

- (instancetype)initWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle
{
    if (self = [super init]) {
        _headerTitle = headerTitle;
        _footerTitle = footerTitle;
    }
    return self;
}

- (instancetype)init
{
    _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStyleGrouped];
    if (self = [super initWithNode:_tableNode]) {
        _tableNode.delegate = self;
        _tableNode.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _rowDescriptor.selectorTitle;
    _selectedItems =
    [self.rowDescriptor.rowType isEqualToString:JTFormRowTypePushSelect]
    ? (self.rowDescriptor.value ? @[self.rowDescriptor.value].mutableCopy : [NSMutableArray array])
    : (self.rowDescriptor.value ? [self.rowDescriptor.value mutableCopy] : [NSMutableArray array]);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeMultipleSelect]) {
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
        for (NSInteger i = 0; i < _selectedItems.count; i++) {
            JTOptionObject *selectOption = _selectedItems[i];
            BOOL exist = false;
            for (JTOptionObject *option in self.rowDescriptor.selectorOptions) {
                if ([option isEqualToOptionObject:selectOption]) {
                    exist = YES;
                    break;
                }
            }
            if (!exist) {
                [indexSet addIndex:i];
            }
        }
        [_selectedItems removeObjectsAtIndexes:indexSet];
        self.rowDescriptor.value = _selectedItems.copy;
    }
    [self.form updateFormRow:self.rowDescriptor];
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
    JTOptionObject *option = self.rowDescriptor.selectorOptions[indexPath.row];
    ASTextCellNode *cellNode = [[ASTextCellNode alloc] init];
    cellNode.accessoryType = [self selectedItemsContainOption:option] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cellNode.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    cellNode.textNode.attributedText = [NSAttributedString attributedStringWithString:[option displayText]
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
        // 多选
        if ([self selectedItemsContainOption:optionObject]) {
            [_selectedItems removeObject:optionObject];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            [_selectedItems addObject:optionObject];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else {
        // 单选
        if ([[self.rowDescriptor.value valueData] jt_isEqual:[optionObject valueData]]) {
            self.rowDescriptor.value = nil;
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            if (self.rowDescriptor.value) {
                NSInteger index = NSNotFound;;
                for (JTOptionObject *selectObject in self.rowDescriptor.selectorOptions) {
                    if ([selectObject jt_isEqual:self.rowDescriptor.value]) {
                        index = [self.rowDescriptor.selectorOptions indexOfObject:selectObject];
                        break;
                    }
                }
                if (index != NSNotFound) {
                    NSIndexPath *oldSelectIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
                    ASTextCellNode *oldCellNode = [tableNode nodeForRowAtIndexPath:oldSelectIndexPath];
                    self.rowDescriptor.value = nil;
                    oldCellNode.accessoryType = UITableViewCellAccessoryNone;
                    
                }
            }
            self.rowDescriptor.value = optionObject;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if (self.modalPresentationStyle == UIModalPresentationPopover) {
            [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        } else if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    [tableNode deselectRowAtIndexPath:indexPath animated:YES];
}

- (ASSizeRange)tableNode:(ASTableNode *)tableNode constrainedSizeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ASSizeRangeMake(CGSizeMake(0, 55.));
}

#pragma mark - helper

- (BOOL)selectedItemsContainOption:(JTOptionObject *)optionObject
{
    if (!optionObject) {
        return NO;
    }
    if (![optionObject isKindOfClass:[JTOptionObject class]]) {
        return NO;
    }
    for (NSInteger i = 0; i < _selectedItems.count; i++) {
        JTOptionObject *selectObject = _selectedItems[i];
        if ([optionObject jt_isEqual:selectObject]) {
            return YES;
        }
    }
    return NO;
}

@end
