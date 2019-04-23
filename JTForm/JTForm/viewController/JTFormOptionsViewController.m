//
//  JTFormOptionsViewController.m
//  JTForm
//
//  Created by dqh on 2019/4/23.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTFormOptionsViewController.h"
#import "JTOptionObject.h"
#import "JTFormSelectViewControllerDelegate.h"

@interface JTFormOptionsViewController () <JTFormSelectViewControllerDelegate, ASTableDelegate, ASTableDataSource>
@property (nonatomic, strong) ASTableNode *tableNode;
@end

@implementation JTFormOptionsViewController

@synthesize rowDescriptor = _rowDescriptor;
@synthesize form = _form;

- (instancetype)init
{
    _tableNode = [[ASTableNode alloc] init];
    if (self = [super initWithNode:_tableNode]) {
        _tableNode.delegate = self;
        _tableNode.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _rowDescriptor.selectorTitle;
    // Do any additional setup after loading the view.
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

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTOptionObject *option = self.rowDescriptor.selectorOptions[indexPath.row];
    ASCellNode *(^ASCellNodeBlock)() = ^ASCellNode *() {
        ASCellNode *cellNode = [[ASCellNode alloc] init];
    };
    
    return ASCellNodeBlock;
}

#pragma mark - ASTableDelegate methods

// Receive a message that the tableView is near the end of its data set and more data should be fetched if necessary.
- (void)tableNode:(ASTableNode *)tableNode willBeginBatchFetchWithContext:(ASBatchContext *)context
{
    [context beginBatchFetching];
    [self loadPageWithContext:context];
}

@end
