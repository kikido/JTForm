//
//  UIButton+PINRemoteImage.h
//  Pods
//
//  Created by Garrett Moon on 8/18/14.
//
//

#import "PINRemoteImageMacros.h"

#if PIN_TARGET_IOS
#import <UIKit/UIKit.h>
#elif PIN_TARGET_MAC
#import <Cocoa/Cocoa.h>
#endif

#import "PINRemoteImageManager.h"
#import "PINRemoteImageCategoryManager.h"

@interface PINButton (PINRemoteImage) <PINRemoteImageCategory>

@end
