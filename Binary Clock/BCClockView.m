//
//  BCClockView.m
//  Binary Clock
//
//  Created by Abhi Beckert on 2012-12-7.
//  Copyright (c) 2012 Abhi Beckert. All rights reserved.
//

#import "BCClockView.h"

@implementation BCClockView

- (void)awakeFromNib
{
  [super awakeFromNib];
  
  self.backgroundColor = [UIColor blackColor];
  
  [self addObserver:self forKeyPath:@"length" options:0 context:NULL];
  
  self.length = BC_CLOCK_DISPLAY_LENGTH;
  
  [self updateSubviewOpacities:NO];
  [NSTimer scheduledTimerWithTimeInterval:[[BCBinaryTime binaryTime] timeIntervalToNextChangeAtPosition:self.length] target:self selector:@selector(update:) userInfo:nil repeats:NO];
}

- (void)update:(NSTimer *)timer
{
  [self updateSubviewOpacities:YES];
  [NSTimer scheduledTimerWithTimeInterval:[[BCBinaryTime binaryTime] timeIntervalToNextChangeAtPosition:self.length] target:self selector:@selector(update:) userInfo:nil repeats:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (object == self) {
    if ([keyPath isEqualToString:@"length"]) {
      [self recreateSubviews];
      [self setNeedsLayout];
      return;
    }
  }
  
  [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)recreateSubviews
{
  for (UIView *subview in self.subviews) {
    [subview removeFromSuperview];
  }
  
  NSInteger length = self.length;
  UIColor *blockFillColor = [UIColor colorWithRed:0.75 green:0.9 blue:1 alpha:1];
  for (int subviewIndex = 0; subviewIndex < length; subviewIndex++) {
    UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    subview.backgroundColor = blockFillColor;
    subview.alpha = 0;
    
    [self addSubview:subview];
  }
}

- (void)layoutSubviews
{
  NSInteger count = self.subviews.count;

  CGFloat minX = 0; // allow for stroke width on left/right
  CGFloat maxX = self.frame.size.width; // allow for stroke width on left/right
  CGFloat blockStrokeWidth = 1;
  CGFloat blockWidth = ((maxX - minX) - (blockStrokeWidth * (count - 1))) / count;
  
  CGFloat blockHeight = blockWidth;
  CGFloat blockY = (self.frame.size.height / 2) - (blockHeight / 2);
  
  int subviewIndex = 0;
  for (UIView *subview in self.subviews) {
    subview.frame = CGRectMake(minX + (subviewIndex * (blockWidth + blockStrokeWidth)), blockY, blockWidth, blockHeight);
    
    subviewIndex++;
  }
}

- (void)updateSubviewOpacities:(BOOL)slowAnimate
{
  BCBinaryTime *time = [BCBinaryTime binaryTime];
  NSInteger count = self.subviews.count;
  NSArray *values = [time binaryValuesWithLength:count];
  
  NSTimeInterval animationDuration = slowAnimate ? 10 : 1;
  NSTimeInterval maxAnimationDuration = [time timeIntervalToNextChangeAtPosition:count];
  if (animationDuration > maxAnimationDuration)
    animationDuration = maxAnimationDuration;


  int subviewIndex = 0;
  for (UIView *subview in self.subviews) {
    CGFloat newAlpha = ((NSNumber *)[values objectAtIndex:subviewIndex]).boolValue ? 1.0 : 0.15;
    
    if (fabsf(subview.alpha - newAlpha) < 0.01) {
      subviewIndex++;
      continue;
    }
    
//    subview.alpha = newAlpha;
    
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                       subview.alpha = newAlpha;
                     }
                     completion:^(BOOL finished){
                       
                     }];
    
    subviewIndex++;
  }
}

//
//- (void)drawRect:(CGRect)rect
//{
//  [self relayoutSubviews];
//  // this is what we will draw
//  BCBinaryTime *time = self.time;
//  NSInteger length = self.length;
//  
//  UIColor *onBlockFillColor = [UIColor colorWithRed:0.75 green:0.9 blue:1 alpha:1];
//  UIColor *offBlockFillColor = [UIColor colorWithRed:0.75 green:0.9 blue:1 alpha:0.175];
//  UIColor *backgroundColor = [UIColor blackColor];
//  
//  CGFloat blockStrokeWidth = 3;
//  
//  // draw black background
//  [backgroundColor set];
//  [[UIBezierPath bezierPathWithRect:rect] fill];
//  return;
//  // draw binary boxes
//  NSArray *values = [time binaryValuesWithLength:length];
//  
//  CGFloat minX = -(blockStrokeWidth / 2); // allow for stroke width on left/right
//  CGFloat maxX = self.frame.size.width + blockStrokeWidth; // allow for stroke width on left/right
//  CGFloat blockWidth = (maxX - minX) / length;
//  
//  CGFloat blockHeight = blockWidth;
//  CGFloat blockY = (self.frame.size.height / 2) - (blockHeight / 2);
//  
//  NSInteger index = 0;
//  for (NSNumber *value in values) {
//    if (value.boolValue) {
//      [onBlockFillColor setFill];
//      [backgroundColor setStroke];
//    } else {
//      [offBlockFillColor setFill];
//      [backgroundColor setStroke];
//    }
//    
//    UIBezierPath *blockPath = [UIBezierPath bezierPathWithRect:CGRectMake(minX + (index * blockWidth), blockY, blockWidth, blockHeight)];
//    blockPath.lineWidth = blockStrokeWidth;
//
//    [blockPath fill];
//    [blockPath strokeWithBlendMode:kCGBlendModeNormal alpha:1];
//    
//    index++;
//  }
//}

@end
