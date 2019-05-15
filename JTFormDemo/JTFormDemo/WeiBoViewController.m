//
//  WeiBoViewController.m
//  JTForm
//
//  Created by dqh on 2019/5/9.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "WeiBoViewController.h"
#import "PhotoModel.h"
#import "IGCell.h"
#import "MJRefresh.h"

#define unsplash_IMAGES_PER_PAGE    30

@interface WeiBoViewController ()
{
    NSURLSessionDataTask *_task;
    NSUInteger     _totalItems;
    
    NSMutableArray<PhotoModel *> *_photos;
    NSMutableArray *_ids;
    JTSectionDescriptor *_section;
    
    BOOL _fetchPageInProgress;
    BOOL _refreshFeedInProgress;
    
    NSUInteger _currentPage;
    NSUInteger _totalPages;
}
@end

@implementation WeiBoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = nil;

    
    _photos = @[].mutableCopy;
    _ids = @[].mutableCopy;
    _currentPage = 0;
    _totalPages = 0;
    _totalItems = -1;
    
    JTFormDescriptor *formDescriptor = [JTFormDescriptor formDescriptor];
    formDescriptor.addAsteriskToRequiredRowsTitle = YES;
    JTSectionDescriptor *section = nil;
    
    section = [JTSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    _section = section;
    
    JTForm *form = [[JTForm alloc] initWithFormDescriptor:formDescriptor];
    form.frame = CGRectMake(0, 0, kJTScreenWidth, kJTScreenHeight-64.);
    [self.view addSubview:form];
    self.form = form;
    
    form.tableNode.view.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tailLoad)];
    form.tableNode.view.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headLoad)];
    
    [self headLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - load

- (void)headLoad
{
    [self refreshFeedWithCompletionBlock:^(NSArray<PhotoModel *> *results) {
        NSMutableArray *temp = @[].mutableCopy;
        [results enumerateObjectsUsingBlock:^(PhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            JTRowDescriptor *row = [JTRowDescriptor formRowDescriptorWithTag:nil rowType:JTFormRowTypeIGCell title:nil];
            row.mode = obj;
            [temp addObject:row];
            
            [self.form.tableView.mj_header endRefreshing];
        }];
        [_section replaceAllRows:[temp copy]];
        
    } numResultsToReturn:20];
}

- (void)tailLoad
{
    [self refreshFeedWithCompletionBlock:^(NSArray<PhotoModel *> *results) {
        NSMutableArray *temp = @[].mutableCopy;
        [results enumerateObjectsUsingBlock:^(PhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            JTRowDescriptor *row = [JTRowDescriptor formRowDescriptorWithTag:nil rowType:JTFormRowTypeIGCell title:nil];
            row.mode = obj;
            [temp addObject:row];
            
            [self.form.tableView.mj_footer endRefreshing];
        }];
        [_section addFormRows:[temp copy]];
        
    } numResultsToReturn:20];
}

#pragma mark - helper

- (void)requestPageWithCompletionBlock:(void (^)(NSArray *))block numResultsToReturn:(NSUInteger)numResults
{
    // only one fetch at a time
    if (_fetchPageInProgress) {
        return;
    } else {
        _fetchPageInProgress = YES;
        [self fetchPageWithCompletionBlock:block numResultsToReturn:numResults];
    }
}

- (void)refreshFeedWithCompletionBlock:(void (^)(NSArray *))block numResultsToReturn:(NSUInteger)numResults
{
    // only one fetch at a time
    if (_refreshFeedInProgress) {
        return;
        
    } else {
        _refreshFeedInProgress = YES;
        
        // FIXME: blow away any other requests in progress
        [self fetchPageWithCompletionBlock:^(NSArray *newPhotos) {
            if (block) {
                block(newPhotos);
            }
           _refreshFeedInProgress = NO;
        } numResultsToReturn:numResults replaceData:YES];
    }
}

#pragma mark - Helper Methods

- (void)fetchPageWithCompletionBlock:(void (^)(NSArray *))block numResultsToReturn:(NSUInteger)numResults
{
    [self fetchPageWithCompletionBlock:block numResultsToReturn:numResults replaceData:NO];
}

- (void)fetchPageWithCompletionBlock:(void (^)(NSArray *))block numResultsToReturn:(NSUInteger)numResults replaceData:(BOOL)replaceData
{
    // early return if reached end of pages
    if (_totalPages) {
        if (_currentPage == _totalPages) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(@[]);
                }
            });
            return;
        }
    }
    NSUInteger numPhotos = (numResults < unsplash_IMAGES_PER_PAGE) ? numResults : unsplash_IMAGES_PER_PAGE;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *newPhotos = [NSMutableArray array];
        NSMutableArray *newIDs = [NSMutableArray array];
        
        @synchronized(self) {
            NSString *urlString = [[@"https://api.unsplash.com/" stringByAppendingString:@"photos?order_by=popular"] stringByAppendingString:@"&client_id=3b99a69cee09770a4a0bbb870b437dbda53efb22f6f6de63714b71c4df7c9642"];
            NSUInteger nextPage      = _currentPage + 1;
            NSString *imageSizeParam = [self imageParameterForClosestImageSize:CGSizeMake(kJTScreenWidth*kJTScreenScale, kJTScreenWidth*kJTScreenScale)];
            NSString *urlAdditions   = [NSString stringWithFormat:@"&page=%lu&per_page=%lu%@", (unsigned long)nextPage, (long)numPhotos, imageSizeParam];
            NSURL *url               = [NSURL URLWithString:[urlString stringByAppendingString:urlAdditions]];
            
            NSURLSession *session    = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
            NSLog(@"[IG] url:%@", url);
            _task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                @synchronized(self) {
                    NSHTTPURLResponse *httpResponse = nil;
                    if (data && [response isKindOfClass:[NSHTTPURLResponse class]]) {
                        httpResponse = (NSHTTPURLResponse *)response;
                        NSArray *objects = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                        
                        if ([objects isKindOfClass:[NSArray class]]) {
                            _currentPage = nextPage;
                            _totalItems = [[httpResponse allHeaderFields][@"x-total"] integerValue];
                            _totalPages  = _totalItems / unsplash_IMAGES_PER_PAGE; // default per page is 10
                            if (_totalItems % unsplash_IMAGES_PER_PAGE != 0) {
                                _totalPages += 1;
                            }
                            
                            NSArray *photos = objects;
                            for (NSDictionary *photoDictionary in photos) {
                                if ([photoDictionary isKindOfClass:[NSDictionary class]]) {
                                    PhotoModel *photo = [[PhotoModel alloc] initWithUnsplashPhoto:photoDictionary];
                                    if (photo) {
                                        if (replaceData || ![_ids containsObject:photo.photoID]) {
                                            [newPhotos addObject:photo];
                                            [newIDs addObject:photo.photoID];
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    @synchronized(self) {
                        if (replaceData) {
                            _photos = [newPhotos mutableCopy];
                            _ids = [newIDs mutableCopy];
                        } else {
                            [_photos addObjectsFromArray:newPhotos];
                            [_ids addObjectsFromArray:newIDs];
                        }
                        if (block) {
                            block(newPhotos);
                        }
                        _fetchPageInProgress = NO;
                    }
                });
            }];
            [_task resume];
        }
    });
}

- (NSString *)imageParameterForClosestImageSize:(CGSize)size
{
    BOOL squareImageRequested = (size.width == size.height) ? YES : NO;
    
    if (squareImageRequested) {
        NSUInteger imageParameterID = [self imageParameterForSquareCroppedSize:size];
        return [NSString stringWithFormat:@"&image_size=%lu", (long)imageParameterID];
    } else {
        return @"";
    }
}

- (NSUInteger)imageParameterForSquareCroppedSize:(CGSize)size
{
    NSUInteger imageParameterID;
    
    if (size.height <= 70) {
        imageParameterID = 1;
    } else if (size.height <= 100) {
        imageParameterID = 100;
    } else if (size.height <= 140) {
        imageParameterID = 2;
    } else if (size.height <= 200) {
        imageParameterID = 200;
    } else if (size.height <= 280) {
        imageParameterID = 3;
    } else if (size.height <= 400) {
        imageParameterID = 400;
    } else {
        imageParameterID = 600;
    }
    
    return imageParameterID;
}
@end
