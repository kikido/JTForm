//
//  JTFormAgent.m
//  JTFormDemo
//
//  Created by dqh on 2020/9/15.
//  Copyright © 2020 dqh. All rights reserved.
//

#import "JTFormAgent.h"
#import <SDWebImage/SDImageCache.h>

@interface JTFormImageCache : NSObject <JTFormImageCache>
@property (nonatomic, strong) SDImageCache *imageCache;
@end

@implementation JTFormImageCache

- (void)storeImage:(UIImage *)image forKey:(NSString *)key
{
    [self.imageCache storeImage:image forKey:key completion:nil];
}

- (UIImage *)imageFromCacheForKey:(NSString *)key
{
    return [self.imageCache imageFromDiskCacheForKey:key];
}

- (void)clearImageCache
{
    [self.imageCache clearMemory];
    [self.imageCache clearDiskOnCompletion:nil];
}
    
- (SDImageCache *)imageCache
{
    if (!_imageCache) {
        _imageCache = [[SDImageCache alloc] initWithNamespace:@"com.jtform.cache" diskCacheDirectory:@"com.jtform.cache"];
    }
    return _imageCache;
}


@end

@implementation JTFormAgent

+ (JTFormAgent *)sharedAgent
{
    static JTFormAgent *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JTFormAgent alloc] init];
        sharedInstance.imageCache = [[JTFormImageCache alloc] init];
    });
    return sharedInstance;
}

@end
