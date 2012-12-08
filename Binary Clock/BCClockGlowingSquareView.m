//
//  BCClockGlowingSquareView.m
//  Binary Clock
//
//  Created by Abhi Beckert on 2012-12-8.
//  Copyright (c) 2012 Abhi Beckert. All rights reserved.
//

#import "BCClockGlowingSquareView.h"

@implementation BCClockGlowingSquareView

- (id)initWithFrame:(CGRect)frame
{
  if (!(self = [super initWithFrame:frame]))
    return nil;
  self.opaque = NO;
  return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  UIColor *strokeColor = [UIColor colorWithRed:0.885 green:0.95 blue:1 alpha:1];
  UIColor *fillColor = [UIColor colorWithRed:0.75 green:0.9 blue:1 alpha:0.85];
  UIColor *shadowColor = [UIColor colorWithRed:0.75 green:0.9 blue:1 alpha:0.6];
  CGFloat shadowSize = ceilf(2.0f * (self.frame.size.width / 3)) / 2.0f;
  CGRect squareRect = CGRectMake(shadowSize, shadowSize, self.frame.size.width - (shadowSize * 2), self.frame.size.width - shadowSize * 2);
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  
  CGContextSetLineWidth(context, 1);
  CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
  CGContextSetFillColorWithColor(context, fillColor.CGColor);
  CGContextSetShadowWithColor(context, CGSizeMake(0, 0), shadowSize, shadowColor.CGColor);
  
  CGContextStrokeRect(context, squareRect);
  CGContextFillRect(context, squareRect);
  
  CGContextRestoreGState(context);
}


@end
