//
//  BCClockView.h
//  Binary Clock
//
//  Created by Abhi Beckert on 2012-12-7.
//  Copyright (c) 2012 Abhi Beckert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCBinaryTime.h"

@interface BCClockView : UIView

@property (nonatomic, readwrite) BCBinaryTime *time;
@property (readwrite) NSInteger length;

@end