//
//  BCClockGlowingSquareView.h
//  Binary Clock
//
//  Created by Abhi Beckert on 2012-12-8.
//  Copyright (c) 2012 Abhi Beckert. All rights reserved.
//

// #if TARGET_OS_IPHONE
// #import <UIKit/UIKit.h>
// #elif TARGET_OS_MAC
#import <Cocoa/Cocoa.h>
// #endif

#import "BCBinaryTime.h"

// #if TARGET_OS_IPHONE
// @interface BCClockGlowingSquareView : UIView
// #elif TARGET_OS_MAC
@interface BCClockGlowingSquareView : NSView {
// #endif
  float _alphaValue;
}

@property (readwrite) float alphaValue;

@end
