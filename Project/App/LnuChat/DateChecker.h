//
//  DateChecker.h
//  lnuchat
//
//  Created by Mikael Melander on 2016-04-13.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateChecker : NSObject

+(NSString*)ReturnCorrectDateSetup:(NSDate *)givenDate;

+(BOOL*)IsItSameDay:(NSDate *)date;
+(BOOL*)IsItSameYear:(NSDate *)date;

@end
