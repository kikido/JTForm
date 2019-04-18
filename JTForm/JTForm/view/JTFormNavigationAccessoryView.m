//
//  JTFormNavigationAccessoryView.m
//  JTForm
//
//  Created by dqh on 2019/4/18.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTFormNavigationAccessoryView.h"

@interface JTFormNavigationAccessoryView ()
@property (nonatomic, strong) UIBarButtonItem *fixedSpace;
@property (nonatomic, strong) UIBarButtonItem *flexbleSpace;
@end

@implementation JTFormNavigationAccessoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44.0)]) {
        NSArray *items = @[
                           self.previousButton,
                           self.fixedSpace,
                           self.nextButton,
                           self.flexbleSpace,
                           self.doneButton
                           ];
        [self setItems:items];
    }
    return self;
}

- (UIBarButtonItem *)previousButton
{
    if (_previousButton == nil) {
        _previousButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:105 target:nil action:nil];
    }
    return _previousButton;
}

- (UIBarButtonItem *)fixedSpace
{
    if (_fixedSpace == nil) {
        _fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        _fixedSpace.width = 26.0;
    }
    return _fixedSpace;
}

- (UIBarButtonItem *)nextButton
{
    if (_nextButton == nil) {
        _nextButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:106 target:nil action:nil];
    }
    return _nextButton;
}

- (UIBarButtonItem *)flexbleSpace
{
    if (_flexbleSpace == nil) {
        _flexbleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    return _flexbleSpace;
}

- (UIBarButtonItem *)doneButton
{
    if (_doneButton == nil) {
        _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
    }
    return _doneButton;
}

@end
