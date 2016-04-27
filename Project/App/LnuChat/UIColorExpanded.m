//
//  UIColorExpanded.m
//  LnuChat
//
//  Created by Mikael Melander on 2016-04-12.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import "UIColorExpanded.h"

@implementation UIColorExpanded

// Coneverts hex to UIColor
+(UIColor *)colorWithHex:(UInt32)col {
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}

// Converts Hex to
+ (UIColor *)colorWithHexString:(NSString *)str {
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [UIColorExpanded colorWithHex:x];
}


@end
