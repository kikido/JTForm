//
//  JTFormDescriptor.m
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTFormDescriptor.h"

@interface JTFormDescriptor ()
@property (nonatomic, strong, readwrite) NSMutableArray *formSections;
@property (nonatomic, strong, readwrite) NSMutableArray *allSections;
@end

@implementation JTFormDescriptor

- (instancetype)init
{
    if (self = [super init]) {
        _formSections = @[].mutableCopy;
        _allSections = @[].mutableCopy;
        _allRowsByTag = @{}.mutableCopy;
        
        _addAsteriskToRequiredRowsTitle = false;
        
        [self addObserver:self forKeyPath:@"formSections" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)  context:nil];
    }
    return self;
}

+ (nonnull instancetype)formDescriptor
{
    return [[[self class] alloc] init];
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (!self.delegate) {
        return;
    }
    if ([keyPath isEqualToString:@"formSections"]) {
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeInsertion)])
        {
            NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            JTSectionDescriptor *section = [self.formSections objectAtIndex:indexSet.firstIndex];
            [self.delegate formSectionHasBeenAdded:section atIndex:indexSet.firstIndex];
        }
        else if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeRemoval)])
        {
            NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            JTSectionDescriptor *section = change[NSKeyValueChangeOldKey][0];
            [self.delegate formSectionHasBeenRemoved:section atIndex:indexSet.firstIndex];
        }
    }
    
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"formSections"];
}


#pragma mark - tag collection

- (void)addRowToTagCollection:(JTRowDescriptor *)row
{
    if ([row.tag jt_isNotEmpty]) {
        self.allRowsByTag[row.tag] = row;
    }
}

- (void)removeRowFromTagCollection:(JTRowDescriptor *)row
{
    if ([row.tag jt_isNotEmpty]) {
        [self.allRowsByTag removeObjectForKey:row.tag];
    }
}

- (JTRowDescriptor *)findRowByTag:(NSString *)tag
{
    if ([tag jt_isNotEmpty]) {
        return self.allRowsByTag[tag];
    } else {
        return nil;
    }
}
@end
