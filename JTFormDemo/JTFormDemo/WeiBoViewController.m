//
//  WeiBoViewController.m
//  JTForm
//
//  Created by dqh on 2019/5/9.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "WeiBoViewController.h"
#import "WBMode.h"
#import "NSObject+YYModel.h"
#import "WBCell.h"

#define unsplash_IMAGES_PER_PAGE    30

@interface WeiBoViewController () <JTFormDelegate>
{
    JTSectionDescriptor *_section;
    NSUInteger _currentPage;
    NSUInteger _totalPages;
}
@end

@implementation WeiBoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
    
    JTFormDescriptor *formDescriptor = [JTFormDescriptor formDescriptor];
    formDescriptor.addAsteriskToRequiredRowsTitle = YES;
    JTSectionDescriptor *section = nil;
    
    section = [JTSectionDescriptor formSection];
    [formDescriptor addSection:section];
    _section = section;

    
    JTForm *form = [[JTForm alloc] initWithDescriptor:formDescriptor];
    form.delegate = self;
    form.frame = CGRectMake(0, 0, kJTScreenWidth, kJTScreenHeight-64.);
    [self.view addSubview:form];
    self.form = form;
    
    [self getLocalData];
}

- (void)tailLoadWithContent:(ASBatchContext *)context
{
    [self getLocalData];
    [context completeBatchFetching:YES];
}

- (void)getLocalData
{
    static NSInteger i = -1;
    i++;
    if (i > 7) {
        i = 7;
    }
   [self dataNamed:[NSString stringWithFormat:@"weibo_%ld.json",i] compelation:^(NSData *data) {
        WBTimelineItem *item = [WBTimelineItem modelWithJSON:data];
        
        JTRowDescriptor *row;
        NSMutableArray *temp = @[].mutableCopy;
        for (WBStatus *status in item.statuses) {
            row = [JTRowDescriptor rowDescriptorWithTag:nil rowType:JTFormRowTypeWBCell title:nil];
            row.mode = status;
            [temp addObject:row];
        }
       dispatch_async(dispatch_get_main_queue(), ^{
           [_section addRows:temp];
       });
    }];
}


- (void)dataNamed:(NSString *)name compelation:(void(^)(NSData *data))completion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
        if (path) {
            NSData *data = [NSData dataWithContentsOfFile:path];
            completion(data);
        }
    });
}

@end
