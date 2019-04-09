//
//  JTSectionDescriptor.m
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTSectionDescriptor.h"
#import "JTFormDescriptor.h"

@implementation JTSectionDescriptor

- (instancetype)init
{
    if (self = [super init]) {
        _formRows = @[].mutableCopy;
        _allRows = @[].mutableCopy;
        
        _footerHeight = 30.;
        _headerHeight = 30.;
    }
    return self;
}

+ (instancetype)formSection
{
    return [[JTSectionDescriptor alloc] init];
}

#pragma mark - add form row

- (void)addFormRow:(JTRowDescriptor *)row
{
    if ([row jt_isNotEmpty]) {
        [self insertFormRow:row inAllRowsAtIndex:self.allRows.count];
        [self insertFormRow:row inFormRowsAtIndex:self.formRows.count];
        [self.formDescriptor addRowToTagCollection:row];
    }
}

- (void)addFormRow:(JTRowDescriptor *)row afterRow:(JTRowDescriptor *)afterRow
{
    if ([row jt_isNotEmpty] && [afterRow jt_isNotEmpty]) {
        [self insertFormRow:row inAllRowsAtIndex:[self.allRows indexOfObject:afterRow] + 1];
        [self insertFormRow:row inFormRowsAtIndex:[self.formRows indexOfObject:afterRow] + 1];
        [self.formDescriptor addRowToTagCollection:row];
    }
}

- (void)addFormRow:(JTRowDescriptor *)row beforeRow:(JTRowDescriptor *)beforeRow
{
    if ([row jt_isNotEmpty] && [beforeRow jt_isNotEmpty]) {
        [self insertFormRow:row inAllRowsAtIndex:[self.allRows indexOfObject:beforeRow] - 1];
        [self insertFormRow:row inFormRowsAtIndex:[self.formRows indexOfObject:beforeRow] - 1];
        [self.formDescriptor addRowToTagCollection:row];
    }
}

#pragma mark - remove form row

- (void)removeFormRow:(JTRowDescriptor *)row{}

- (void)removeFormRowWithTag:(NSString *)tag{}

- (void)removeFormRowAtIndex:(NSUInteger)index{}

- (void)moveRowAtIndexPath:(NSIndexPath *)sourceIndex toIndexPath:(NSIndexPath *)destinationIndex{}

#pragma mark - all rows

- (void)insertFormRow:(JTRowDescriptor *)row inAllRowsAtIndex:(NSUInteger)index
{
    if (index == NSNotFound) {
        index = self.allRows.count;
    }
    if (index < 0) {
        index = 0;
    }
    if ([self.allRows indexOfObject:row] == NSNotFound) {
        [self.allRows insertObject:row atIndex:index];
    }
}

- (void)removeFormRowInAllRows:(JTFormDescriptor *)row
{
    
}

#pragma mark - form rows

- (void)insertFormRow:(JTRowDescriptor *)row inFormRowsAtIndex:(NSUInteger)index
{
    if (index == NSNotFound) {
        index = self.formRows.count;
    }
    if (index < 0) {
        index = 0;
    }
    if (!row.hidden) {
        if ([self.formRows indexOfObject:row] == NSNotFound) {
            // fixme
            [self.formRows insertObject:row atIndex:index];
        }
    }
}

@end
