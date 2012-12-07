//
//  BCViewController.m
//  Binary Clock
//
//  Created by Abhi Beckert on 2012-12-7.
//  Copyright (c) 2012 Abhi Beckert. All rights reserved.
//

#import "BCViewController.h"

@interface BCViewController ()

@end

@implementation BCViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
	
  [NSTimer scheduledTimerWithTimeInterval:BC_CLOCK_DISPLAY_UPDATE_TIME_INTERVAL target:self selector:@selector(update:) userInfo:nil repeats:YES];
}

- (void)update:(NSTimer *)timer
{
  [self.clockView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
