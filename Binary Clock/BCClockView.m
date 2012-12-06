//
//  BCClockView.m
//  Binary Clock
//
//  Created by Abhi Beckert on 2012-12-7.
//  Copyright (c) 2012 Abhi Beckert. All rights reserved.
//

#import "BCClockView.h"

@implementation BCClockView

- (void)drawRect:(CGRect)rect
{
  // this is what we will draw
  BCBinaryTime *time = [BCBinaryTime binaryTime];
  NSUInteger length = BC_CLOCK_DISPLAY_LENGTH;
  
  UIColor *onBlockFillColor = [UIColor colorWithRed:0.75 green:0.9 blue:1 alpha:1];
  UIColor *offBlockFillColor = [UIColor colorWithRed:0.75 green:0.9 blue:1 alpha:0.175];
  UIColor *backgroundColor = [UIColor blackColor];
  
  CGFloat blockStrokeWidth = 3;
  
  // draw black background
  [backgroundColor set];
  [[UIBezierPath bezierPathWithRect:rect] fill];
  
  // draw binary boxes
  NSArray *values = [time binaryValuesWithLength:length];
  
  CGFloat minX = -(blockStrokeWidth / 2); // allow for stroke width on left/right
  CGFloat maxX = self.frame.size.width + blockStrokeWidth; // allow for stroke width on left/right
  CGFloat blockWidth = (maxX - minX) / length;
  
  CGFloat blockHeight = blockWidth;
  CGFloat blockY = (self.frame.size.height / 2) - (blockHeight / 2);
  
  NSUInteger index = 0;
  for (NSNumber *value in values) {
    if (value.boolValue) {
      [onBlockFillColor setFill];
      [backgroundColor setStroke];
    } else {
      [offBlockFillColor setFill];
      [backgroundColor setStroke];
    }
    
    UIBezierPath *blockPath = [UIBezierPath bezierPathWithRect:CGRectMake(minX + (index * blockWidth), blockY, blockWidth, blockHeight)];
    blockPath.lineWidth = blockStrokeWidth;

    [blockPath fill];
    [blockPath strokeWithBlendMode:kCGBlendModeNormal alpha:1];
    
    index++;
  }
}

@end
