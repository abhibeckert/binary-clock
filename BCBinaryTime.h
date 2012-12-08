//
//  BCBinaryTime.h
//  Binary Clock
//
//  Created by Abhi Beckert on 2012-12-7.
//  Copyright (c) 2012 Abhi Beckert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCBinaryTime : NSObject

+ (BCBinaryTime *)binaryTimeWithDate:(NSDate *)date;
+ (BCBinaryTime *)binaryTime;

- (id)initWithDate:(NSDate *)date; // designated. if date is nil, current date is used

- (NSArray *)binaryValuesWithLength:(NSInteger)length; // returns an array of NSNumber booleans, representing this binary time

+ (NSTimeInterval)timeIntervalBetweenChangesAtPosition:(NSInteger)position;
- (NSTimeInterval)timeIntervalToNextChangeAtPosition:(NSInteger)position;

@end
