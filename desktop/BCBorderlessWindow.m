//
//  BCBorderlessWindow.m
//  Binary Clock
//
//  Created by Abhi Beckert on 2012-12-8.
//  Copyright (c) 2012 Abhi Beckert. All rights reserved.
//

#import "BCBorderlessWindow.h"

@implementation BCBorderlessWindow

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)windowStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)deferCreation
{
  windowStyle = NSBorderlessWindowMask;
  
  if (!(self = [super initWithContentRect:contentRect styleMask:windowStyle backing:bufferingType defer:deferCreation]))
    return nil;
  
  [self setOpaque:NO];
  [self setBackgroundColor:[NSColor clearColor]];
  
  return self;
}

- (BOOL)canBecomeKeyWindow
{
  return YES;
}

@end
