//
//  DateChecker.m
//  lnuchat
//
//  Created by Mikael Melander on 2016-04-02.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import "DateChecker.h"

@implementation DateChecker

/*
 Given the objects created date, calculates a return string apporpirate to the time passed.
 */
+(NSString *)ReturnCorrectDateSetup:(NSDate *)givenDate {
    NSString *result;
    
    NSTimeInterval difference = [[NSDate date] timeIntervalSinceDate:givenDate];
    NSUInteger diff = difference;
    
    if (diff < 60 || givenDate == NULL) { // NULL because when created locally should not be empty.
        result = NSLocalizedString(@"NOW", @"");
    }
    else if (diff < 300 && diff > 60) {
        result = NSLocalizedString(@"5min", @"");
    }
    else if (diff < 600 && diff > 300) {
        result = NSLocalizedString(@"10min", @"");
    }
    else if (diff < 1800 && diff > 600) {
        result = NSLocalizedString(@"30min", @"");
    }
    else if (diff < 3600 && diff > 1800) {
        result = NSLocalizedString(@"1h", @"");
    }
    // BREAKING HERE BECAUSE TRYING TO FIND A GOOD USERFRIENDRLY WAY TO DISPLAY TIME
    /*else if (diff < 7200 && diff > 3600) {
        result = NSLocalizedString(@"2h", @"");
    }
    else if (diff < 10800 && diff > 7200) {
        result = NSLocalizedString(@"3h", @"");
    }
    else if (diff < 14400 && diff > 10800) {
        result = @"Mindre än 4h sedan";
    }
    else if (diff < 18000 && diff > 14400) {
        result = @"Mindre än 5h sedan";
    }
    else if (diff < 21600 && diff > 18000) {
        result = @"Mindre än 6h sedan";
    }
    else if (diff < 25200 && diff > 21600) {
        result = @"Mindre än 7h sedan";
    }
    else if (diff < 28800 && diff > 25200) {
        result = @"Mindre än 8h sedan";
    }
    else if (diff < 32400 && diff > 28800) {
        result = @"Mindre än 9h sedan";
    }
    else if (diff < 36000 && diff > 32400) {
        result = @"Mindre än 10h sedan";
    }
    else if (diff < 39600 && diff > 36000) {
        result = @"Mindre än 11h sedan";
    }
    else if (diff < 43200 && diff > 39600) {
        result = @"Mindre än 12h sedan";
    }*/ else if ([DateChecker IsItSameDay:givenDate]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        result = [formatter stringFromDate:givenDate];
    } else if ([DateChecker IsItSameYear:givenDate]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm dd/MM"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        result = [formatter stringFromDate:givenDate];
    }
    else  {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm dd/MM - yy"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        result = [formatter stringFromDate:givenDate];
    }
    
    
    return result;
}

/*
 Checks if the date of an object is the same as the current date.
 Returning a bool
 */
+(BOOL*)IsItSameDay:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    NSString *givenDate = [formatter stringFromDate:date];
    NSString *currentDate = [formatter stringFromDate:[NSDate date]];
    if ([givenDate isEqualToString:currentDate]) {
        return YES;
    } else {
        return NO;
    }

    
}

+(BOOL*)IsItSameYear:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    NSString *givenDate = [formatter stringFromDate:date];
    NSString *currentDate = [formatter stringFromDate:[NSDate date]];
    if ([givenDate isEqualToString:currentDate]) {
        return YES;
    } else {
        return NO;
    }
    
    
}

@end
