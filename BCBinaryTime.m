//
//  BCBinaryTime.m
//  Binary Clock
//
//  Created by Abhi Beckert on 2012-12-7.
//  Copyright (c) 2012 Abhi Beckert. All rights reserved.
//

#import "BCBinaryTime.h"

@interface BCBinaryTime ()

@property (retain) NSDate *date;

@end

@implementation BCBinaryTime

+ (BCBinaryTime *)binaryTimeWithDate:(NSDate *)date
{
  return [[[[BCBinaryTime class] alloc] initWithDate:date] autorelease];
}

+ (BCBinaryTime *)binaryTime
{
  return [[[[BCBinaryTime class] alloc] initWithDate:nil] autorelease];
}


+ (NSTimeInterval)timeIntervalBetweenChangesAtPosition:(NSInteger)position;
{
  NSTimeInterval result = 86400; // seconds in one day
  
  int i;
  for (i = 0; i < position; i++) {
    result /= 2;
  }
  
  return result;
}

- (NSTimeInterval)timeIntervalToNextChangeAtPosition:(NSInteger)position
{
  NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
  
  // init "begining" timestamp as midnight this morning
  NSCalendarDate *midnightThisMorning = [NSCalendarDate calendarDate];
  NSDateComponents *comps = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:midnightThisMorning];
  midnightThisMorning = [gregorian dateFromComponents:comps];
  NSTimeInterval beginning = [midnightThisMorning timeIntervalSince1970];
  
  // init "end" timestamp as as midnight tonight
  comps = [[[NSDateComponents alloc] init] autorelease];
  [comps setDay:1];
  NSDate *midnightTonight = [gregorian dateByAddingComponents:comps toDate:midnightThisMorning options:0];
  NSTimeInterval end = midnightTonight.timeIntervalSince1970;
  
  // get a timestamp for now
  // NSTimeInterval now = [[NSDate date] timeIntervalSince1970]; // cannot use this because a GNUstep bug will cause midnightThisMorning/midnightTonight to be 1970 instead of the current year. Fixed in GNUstep trunk as of January 2013.
  NSCalendarDate *currentDate = [NSCalendarDate calendarDate];
  NSTimeInterval now = beginning + ([currentDate hourOfDay] * 60 * 60) + ([currentDate minuteOfHour] * 60) + [currentDate secondOfMinute] + ([currentDate timeIntervalSince1970] - floor([currentDate timeIntervalSince1970]));
  
  // check if "now" is closer to "begining" or "end", then cut the begining/end times in half and repeat up to the desired length
  NSTimeInterval nextChange = 0;
  int i;
  for (i = 0; i < position; i++) {
    if ((now - beginning) < (end - now)) {
      nextChange = beginning + ((end - beginning) / 2);
      
      end = (end - ((end - beginning) / 2));
    } else {
      nextChange = end;
      
      beginning = (beginning + ((end - beginning) / 2));
    }
  }
  
  return nextChange - now;
}

- (id)init
{
  return [self initWithDate:nil];
}

- (id)initWithDate:(NSDate *)date
{
  if (!(self = [super init]))
    return nil;
  
  if (!date)
    date = [NSDate date];
  
  self.date = date;
  
  return self;
}

- (void)dealloc
{
  [_date release], _date = nil;
  
  [super dealloc];
 }

- (NSDate *)date
{
  return _date;
}

- (void)setDate:(NSDate *)date;
{
  [_date autorelease];
  _date = [date retain];
}

- (NSArray *)binaryValuesWithLength:(NSInteger)length
{
  NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
  
  // init "begining" timestamp as midnight this morning
  NSCalendarDate *midnightThisMorning = [NSCalendarDate calendarDate];
  NSDateComponents *comps = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:midnightThisMorning];
  midnightThisMorning = [gregorian dateFromComponents:comps];
  NSTimeInterval beginning = [midnightThisMorning timeIntervalSince1970];
  
  // init "end" timestamp as as midnight tonight
  comps = [[[NSDateComponents alloc] init] autorelease];
  [comps setDay:1];
  NSDate *midnightTonight = [gregorian dateByAddingComponents:comps toDate:midnightThisMorning options:0];
  NSTimeInterval end = midnightTonight.timeIntervalSince1970;
  
  // get a timestamp for now
  // NSTimeInterval now = [[NSDate date] timeIntervalSince1970]; // cannot use this because a GNUstep bug will cause midnightThisMorning/midnightTonight to be 1970 instead of the current year. Fixed in GNUstep trunk as of January 2013.
  NSCalendarDate *currentDate = [NSCalendarDate calendarDate];
  NSTimeInterval now = beginning + ([currentDate hourOfDay] * 60 * 60) + ([currentDate minuteOfHour] * 60) + [currentDate secondOfMinute] + ([currentDate timeIntervalSince1970] - floor([currentDate timeIntervalSince1970]));
  
  
  // init values array
  NSNumber *on = [NSNumber numberWithBool:YES];
  NSNumber *off = [NSNumber numberWithBool:NO];
  NSMutableArray *values = [[[NSMutableArray alloc] initWithCapacity:length] autorelease];
  
  // add "on" or "off" to values by checking if "now" is closer to "begining" or "end", then cut the begining/end times in half and repeat up to the desired length
  int i;
  for (i = 0; i < length; i++) {
    // NSLog(@"from: %@ to %@ equals %@", [NSDate dateWithTimeIntervalSince1970:beginning], [NSDate dateWithTimeIntervalSince1970:end], (now - beginning) < (end - now) ? @"0" : @"1");
    
    if ((now - beginning) < (end - now)) {
      [values addObject:off];
      end = (end - ((end - beginning) / 2));
    } else {
      [values addObject:on];
      beginning = (beginning + ((end - beginning) / 2));
    }
  }
  
  return [values copy];
}

- (NSString *)description
{
  NSMutableString *description = [NSMutableString string];
  
  int groupCount = 0;
  for (NSNumber *value in [self binaryValuesWithLength:16]) {
    if (groupCount == 4) {
      [description appendString:@" "];
      groupCount = 0;
    }
    [description appendString:value.boolValue ? @"1" : @"0"];
    groupCount++;
  }
  
  [description appendString:@" ("];
  [description appendString:self.date.description];
  [description appendString:@")"];
  
  return description;
}

@end
