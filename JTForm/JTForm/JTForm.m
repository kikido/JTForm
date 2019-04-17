//
//  JTForm.m
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTForm.h"
#import "JTBaseCell.h"

@interface JTForm () <ASTableDelegate, ASTableDataSource>
@property (nonatomic, strong) JTFormDescriptor *formDescriptor;
@end

@implementation JTForm

//- (instancetype)init
//{
//    @throw [NSException exceptionWithName:NSGenericException reason:@"`-init` unavailable. Use `-formRowDescriptorWithTag:rowType:title:` instead" userInfo:nil];
//    return nil;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    @throw [NSException exceptionWithName:NSGenericException reason:@"`-initWithFrame:` unavailable. Use `-formRowDescriptorWithTag:rowType:title:` instead" userInfo:nil];
//    return nil;
//}
//
//- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    @throw [NSException exceptionWithName:NSGenericException reason:@"`-initWithCoder:` unavailable. Use `-formRowDescriptorWithTag:rowType:title:` instead" userInfo:nil];
//    return nil;
//}


- (instancetype)initWithFormDescriptor:(JTFormDescriptor *)formDescriptor
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.backgroundColor = [UIColor blueColor];
        _formDescriptor = formDescriptor;
        [self initializeForm];
    }
    return self;
}

- (void)initializeForm
{
    _tableNode            = [[ASTableNode alloc] initWithStyle:UITableViewStyleGrouped];
    _tableNode.dataSource = self;
    _tableNode.delegate   = self;
    [self addSubnode:_tableNode];
}


// fixme 看看demo是什么时候给frame的
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    _tableNode.frame = self.frame;
}

- (void)dealloc
{
    self.tableNode.delegate = nil;
    self.tableNode.dataSource = nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    view.backgroundColor = [UIColor redColor];
    return view;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 40.;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.;
//}

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
    JTRowDescriptor *rowDescriptor = [self.formDescriptor formRowAtIndex:indexPath];
    JTBaseCell *cell = [rowDescriptor cellInForm];
    [self upadteCell:cell];
    
    return cell;
}

#pragma mark - ASTableDelegate

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//- (ASSizeRange)tableNode:(ASTableNode *)tableNode constrainedSizeForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGSize max = CGSizeMake(0, 200);
//    return ASSizeRangeMake(max);
//}

#pragma mark - cell

- (void)upadteCell:(JTBaseCell *)cell
{
    [cell update];
    [cell.rowDescriptor.cellConfigAfterUpdate enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [cell setValue:obj == [NSNull null] ? nil : obj forKeyPath:key];
    }];
    if (cell.rowDescriptor.disabled) {
        [cell.rowDescriptor.cellConfigWhenDisabled enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [cell setValue:(obj == [NSNull null] ? nil : obj) forKeyPath:key];
        }];
    }
}

#pragma mark - Cell Classes

+ (NSMutableDictionary *)cellClassesForRowDescriptorTypes
{
    static NSMutableDictionary * _cellClassesForRowDescriptorTypes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cellClassesForRowDescriptorTypes = @{
                                              JTFormRowTypeDefault : [JTDefaultCell class],
                                              JTFormRowTypeText : [JTFormTextFieldCell class]
                                              }.mutableCopy;
    });
    return _cellClassesForRowDescriptorTypes;
}


@end
