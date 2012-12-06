//
//  BCViewController.h
//  Binary Clock
//
//  Created by Abhi Beckert on 2012-12-7.
//  Copyright (c) 2012 Abhi Beckert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCClockView.h"

@interface BCViewController : UIViewController

@property (weak, nonatomic) IBOutlet BCClockView *clockView;

@end
