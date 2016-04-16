//
//  ExtraFucntions.m
//  lnuchat
//
//  Created by Mikael Melander on 2016-04-06.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import "ExtraFucntions.h"

@implementation ExtraFucntions


+(NSMutableString *)FirstLetters:(NSString *)str {
    NSMutableString * firstCharacters = [NSMutableString string];
    NSArray * words = [str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (NSString * word in words) {
        if ([word length] > 0) {
            NSString * firstLetter = [word substringToIndex:1];
            [firstCharacters appendString:[firstLetter uppercaseString]];
        }
    }

    return [firstCharacters uppercaseString];
}

@end
