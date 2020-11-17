//
//  JTFormAgent.h
//  JTFormDemo
//
//  Created by dqh on 2020/9/15.
//  Copyright © 2020 dqh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JTFormImageCache <NSObject>

/** 保存图片到缓存中 */
- (void)storeImage:(UIImage *)image forKey:(NSString *)key;

/** 从缓存中查找图片 */
- (UIImage *)imageFromCacheForKey:(NSString *)key;

/** 清除图片缓存 */
- (void)clearImageCache;

@end

@interface JTFormAgent : NSObject

/** 实现了 JTFormImageCache 协议的实例，用于完成图片缓存的功能。你可以自定义实现该协议的执行者 */
@property (nonatomic, strong) id<JTFormImageCache> imageCache;

+ (JTFormAgent *)sharedAgent;

@end

NS_ASSUME_NONNULL_END
