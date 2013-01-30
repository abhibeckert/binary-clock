//
//  BCClockView.h
//  Binary Clock
//
//  Created by Abhi Beckert on 2012-12-7.
//  Copyright (c) 2012 Abhi Beckert. All rights reserved.
//

//#if TARGET_OS_IPHONE
// #import <UIKit/UIKit.h>
// #elif TARGET_OS_MAC
#import <Cocoa/Cocoa.h>
// #import <QuartzCore/QuartzCore.h>
// #endif

#import "BCBinaryTime.h"

// #if TARGET_OS_IPHONE
// @interface BCClockView : UIView
// #elif TARGET_OS_MAC
@interface BCClockView : NSView
{
  BCBinaryTime *_time;
  NSInteger _length;
}
// #endif

@property (retain, nonatomic, readwrite) BCBinaryTime *time;
@property (readwrite) NSInteger length;

@end
