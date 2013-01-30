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
  
  return self;
}

- (void)awakeFromNib
{
  [self setOpaque:NO];
  // [self setBackgroundColor:[NSColor clearColor]]; // if compositing is enabled, this should set the background to clear. but compositing is buggy with my gfx card, so I set it to white instead (which is the colour of my desktop picture). TODO: add a user default for this.
  [self setBackgroundColor:[NSColor whiteColor]];
  [self setLevel:NSDesktopWindowLevel - 10]; // this should hide the window from the task bar and alt-tab on linux, but it doesn't seem to work
}

- (BOOL)canBecomeKeyWindow
{
  return YES;
}

- (BOOL)isExcludedFromWindowsMenu
{
  return NO;
}


@end
