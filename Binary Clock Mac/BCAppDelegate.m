//
//  BCAppDelegate.m
//  Binary Clock Mac
//
//  Created by Abhi Beckert on 2012-12-8.
//  Copyright (c) 2012 Abhi Beckert. All rights reserved.
//

#import "BCAppDelegate.h"

@implementation BCAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"BCClockBlockCount": @"8"}];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
