//
//  BCClockView.m
//  Binary Clock
//
//  Created by Abhi Beckert on 2012-12-7.
//  Copyright (c) 2012 Abhi Beckert. All rights reserved.
//

#import "BCClockView.h"
#import "BCClockGlowingSquareView.h"

@implementation BCClockView

- (void)awakeFromNib
{
  [super awakeFromNib];
  
  self.backgroundColor = [UIColor blackColor];
  
  [self addObserver:self forKeyPath:@"length" options:0 context:NULL];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defaultsDidChange:) name:NSUserDefaultsDidChangeNotification object:nil];
  
  NSString *lengthStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"BCClockBlockCount"];
  if (!lengthStr || lengthStr.intValue == 0) {
    lengthStr = @"8";
  }
  self.length = lengthStr.intValue;
  
  [self recreateSubviews];
  [self setNeedsLayout];
  
  [self update:nil];
}

- (void)defaultsDidChange:(NSNotification *)notif
{
  NSString *lengthStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"BCClockBlockCount"];
  if (!lengthStr || lengthStr.intValue == 0) {
    lengthStr = @"8";
  }
  NSInteger newLength = lengthStr.intValue;
  if (newLength != self.length) {
    self.length = newLength;
    
    [self recreateSubviews];
    [self setNeedsLayout];
    
    [self update:nil];

  }
}

- (void)update:(NSTimer *)timer
{
  [self updateSubviewOpacities];
  
  [NSTimer scheduledTimerWithTimeInterval:[[BCBinaryTime binaryTime] timeIntervalToNextChangeAtPosition:self.length] target:self selector:@selector(update:) userInfo:nil repeats:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (object == self) {
    if ([keyPath isEqualToString:@"length"]) {
      
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
  for (int subviewIndex = 0; subviewIndex < length; subviewIndex++) {
    BCClockGlowingSquareView *subview = [[BCClockGlowingSquareView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    subview.alpha = 0;
    
    [self addSubview:subview];
  }
}

- (void)layoutSubviews
{
  NSInteger count = self.subviews.count;
  
  CGFloat minX = 0;
  CGFloat maxX = self.frame.size.width;
  CGFloat blockWidth = (maxX - minX) / count;
  CGFloat shadowOffset = blockWidth / 1.1;
  
  CGFloat blockHeight = blockWidth;
  CGFloat blockY = (self.frame.size.height / 2) - (blockHeight / 2);
  
  int subviewIndex = 0;
  for (UIView *subview in self.subviews) {
    CGRect frame = CGRectMake(minX + (subviewIndex * blockWidth), blockY, blockWidth, blockHeight);
    
    frame.origin.x = floorf(2.0f * (frame.origin.x - shadowOffset)) / 2.0f;
    frame.origin.y = floorf(2.0f * (frame.origin.y - shadowOffset)) / 2.0f;
    frame.size.width = ceilf(2.0f * (frame.size.width + shadowOffset * 2)) / 2.0f;
    frame.size.height = ceilf(2.0f * (frame.size.height + shadowOffset * 2)) / 2.0f;
    
    subview.frame = frame;
    subviewIndex++;
  }
}

- (void)updateSubviewOpacities
{
  BCBinaryTime *time = [BCBinaryTime binaryTime];
  NSInteger count = self.subviews.count;
  NSArray *values = [time binaryValuesWithLength:count];
  
  NSTimeInterval animationDuration = 5;
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
