//
//  BCAppDelegate.m
//  Binary Clock Mac
//
//  Created by Abhi Beckert on 2012-12-8.
//  Copyright (c) 2012 Abhi Beckert. All rights reserved.
//

#import "BCAppDelegate.h"
#import "BCBinaryTime.h"

@implementation BCAppDelegate

- (NSWindow *)window
{
  return _window;
}

- (void)setWindow:(NSWindow *)window
{
  [_window autorelease];
  _window = [window retain];
}

- (void)dealloc
{
  [_window release], _window = nil;
  [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
  [defaults setObject:@"8" forKey:@"BCClockBlockCount"];
  
  [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
