//
//  BCClockView.m
//  Binary Clock
//
//  Created by Abhi Beckert on 2012-12-7.
//  Copyright (c) 2012 Abhi Beckert. All rights reserved.
//

#import "BCClockView.h"
#import "BCClockGlowingSquareView.h"

@interface BCClockView ()

- (void)recreateSubviews;
- (void)update:(NSTimer *)timer;
- (void)updateSubviewOpacities;
- (void)layoutSubviews;

@end

@implementation BCClockView

- (BCBinaryTime *)time
{
  return _time;
}

- (void)setTime:(BCBinaryTime *)time
{
  [_time autorelease];
  _time = [time retain];
}

- (NSInteger)length
{
  return _length;
}

- (void)setLength:(NSInteger)length
{
  _length = length;
}

- (void)dealloc
{
  [_time release], _time = nil;
  [super dealloc];
}

- (void)awakeFromNib
{
  // [super awakeFromNib];

// #if TARGET_OS_IPHONE
//   self.backgroundColor = [UIColor blackColor];
// #elif TARGET_OS_MAC
//   // mac view is transparent
// #endif
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defaultsDidChange:) name:NSUserDefaultsDidChangeNotification object:nil];
  
  NSString *lengthStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"BCClockBlockCount"];
  if (!lengthStr || lengthStr.intValue == 0) {
    lengthStr = @"16";
  }
  self.length = lengthStr.intValue;
  
  [self recreateSubviews];
  
  [self update:nil];
}

- (void)defaultsDidChange:(NSNotification *)notif
{
// #if TARGET_OS_IPHONE
//   NSString *lengthStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"BCClockBlockCount"];
//   if (!lengthStr || lengthStr.intValue == 0) {
//     lengthStr = @"8";
//   }
//   NSInteger newLength = lengthStr.intValue;
//   if (newLength != self.length) {
//     self.length = newLength;
//     [self recreateSubviews];
//     [self update:nil];
//   }
// #elif TARGET_OS_MAC
//   // causes weird/occasional crash on OS X. so we tell the user to relaunch the app instead
// #endif
}

- (void)update:(NSTimer *)timer
{
  [self updateSubviewOpacities];
  
  [NSTimer scheduledTimerWithTimeInterval:[[BCBinaryTime binaryTime] timeIntervalToNextChangeAtPosition:self.length] target:self selector:@selector(update:) userInfo:nil repeats:NO];
}

- (void)recreateSubviews
{
// #if TARGET_OS_IPHONE
//   for (UIView *subview in self.subviews) {
// #elif TARGET_OS_MAC
  for (NSView *subview in self.subviews) {
// #endif
    [subview removeFromSuperview];
  }
  
  
  NSInteger length = self.length;
  int subviewIndex;
  for (subviewIndex = 0; subviewIndex < length; subviewIndex++) {
    BCClockGlowingSquareView *subview = [[[BCClockGlowingSquareView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)] autorelease];
    
// #if TARGET_OS_IPHONE
//     subview.alpha = 0;
// #elif TARGET_OS_MAC
    subview.alphaValue = 0;
// #endif
    
    [self addSubview:subview];
  }
  
// #if TARGET_OS_IPHONE
//   [self setNeedsLayout];
// #elif TARGET_OS_MAC
  [self layoutSubviews];
// #endif
}
  
// #if TARGET_OS_IPHONE
//   // no need to do this, layoutSubviews called automatically
// #elif TARGET_OS_MAC
- (void) setFrameSize:(NSSize)newSize
{
  [super setFrameSize:newSize];
  
  [self layoutSubviews];
}
// #endif

- (void)layoutSubviews
{
  NSInteger count = self.subviews.count;
  
// #if TARGET_OS_IPHONE // assume retina; round to nearest half-point and aim for first/last block equal distance from screen edge
//   CGFloat fourBitExtraMargin = (self.frame.size.width / count) / 9;
//   CGFloat minX = 0;
//   CGFloat maxX = self.frame.size.width - ((floorf(count / 4) - 1) * fourBitExtraMargin);
//   CGFloat blockWidth = (maxX - minX) / count;
//   CGFloat shadowOffset = blockWidth / 1.1;
// #elif TARGET_OS_MAC // assume non retina; floor/ciel to nearest point
  CGFloat fourBitExtraMargin = (self.frame.size.width / count) / 9;
  CGFloat minX = (self.frame.size.width / count) / 1.5;
  CGFloat maxX = (self.frame.size.width - ((self.frame.size.width / count) / 1.5)) - ((floorf(count / 4) - 1) * fourBitExtraMargin);
  CGFloat blockWidth = floorf((maxX - minX) / count);
  CGFloat shadowOffset = floorf(blockWidth / 1.1);
// #endif
  
  CGFloat blockHeight = blockWidth;
  CGFloat blockY = (self.frame.size.height / 2) - (blockHeight / 2);
  
  int subviewIndex = 0;
// #if TARGET_OS_IPHONE
//   for (UIView *subview in self.subviews) {
// #elif TARGET_OS_MAC
  for (NSView *subview in self.subviews) {
// #endif
    NSRect frame = NSMakeRect(minX + (subviewIndex * blockWidth), blockY, blockWidth, blockHeight);
    frame.origin.x += floorf(subviewIndex / 4) * fourBitExtraMargin;
    
// #if TARGET_OS_IPHONE // assume retina; round to nearest half-point and aim for first/last block equal distance from screen edge
//     frame.origin.x = floorf(2.0f * (frame.origin.x - shadowOffset)) / 2.0f;
//     frame.origin.y = floorf(2.0f * (frame.origin.y - shadowOffset)) / 2.0f;
//     frame.size.width = ceilf(2.0f * (frame.size.width + shadowOffset * 2)) / 2.0f;
//     frame.size.height = ceilf(2.0f * (frame.size.height + shadowOffset * 2)) / 2.0f;
// #elif TARGET_OS_MAC // assume non retina; floor/ciel to nearest point
    frame.origin.x = floorf(frame.origin.x - shadowOffset);
    frame.origin.y = floorf(frame.origin.y - shadowOffset);
    frame.size.width = ceilf(frame.size.width + shadowOffset * 2);
    frame.size.height = ceilf(frame.size.height + shadowOffset * 2);
// #endif
    
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
// #if TARGET_OS_IPHONE
//   for (UIView *subview in self.subviews) {
//     CGFloat newAlpha = ((NSNumber *)[values objectAtIndex:subviewIndex]).boolValue ? 1.0 : 0.15;
// #elif TARGET_OS_MAC
  for (BCClockGlowingSquareView *subview in self.subviews) {
    // [subview setHidden:(((NSNumber *)[values objectAtIndex:subviewIndex]).boolValue == NO)];
   float newAlpha = ((NSNumber *)[values objectAtIndex:subviewIndex]).boolValue ? 1.0 : 0.1;
// #endif
    
// #if TARGET_OS_IPHONE
//     if (fabsf(subview.alpha - newAlpha) < 0.01) {
// #elif TARGET_OS_MAC
   if (fabsf(subview.alphaValue - newAlpha) < 0.01) {
// #endif
      subviewIndex++;
      continue;
    }


    subview.alphaValue = newAlpha;
// #if TARGET_OS_IPHONE
//     [UIView animateWithDuration:animationDuration
//                           delay:0
//                         options:UIViewAnimationCurveEaseIn
//                      animations:^{
//                        subview.alpha = newAlpha;
//                      }
//                      completion:^(BOOL finished){
                       
//                      }];
// #elif TARGET_OS_MAC
      // [NSAnimationContext beginGrouping];
      // NSAnimationContext.currentContext.duration = animationDuration;
      // NSAnimationContext.currentContext.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
      // [subview.animator setAlphaValue:newAlpha];
      // [NSAnimationContext endGrouping];
// #endif
    
    subviewIndex++;
  }
}

// #if TARGET_OS_IPHONE
// // no window to move around...
// #elif TARGET_OS_MAC
- (void)mouseDown:(NSEvent *)event
{
  NSPoint originalMouseLocation = [NSEvent mouseLocation];
  NSRect originalFrame = self.window.frame;
  
  while (YES)
  {
    NSEvent *newEvent = [self.window nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
    
    if ([newEvent type] == NSLeftMouseUp)
      break;
    
    NSPoint newMouseLocation = [NSEvent mouseLocation];
    
    NSRect newFrame = originalFrame;
    newFrame.origin.x -= (originalMouseLocation.x - newMouseLocation.x);
    newFrame.origin.y -= (originalMouseLocation.y - newMouseLocation.y);
    
    [self.window setFrame:newFrame display:YES animate:NO];
  }
}
// #endif

@end
