//
//  ErrorHandler.h
//  LnuChat
//
//  Created by Mikael Melander on 2016-04-12.
//  Copyright © 2016 mm222ev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"

@interface ErrorHandler : NSObject

+(void)handleParseError:(NSError *)error;

+(BOOL)hasAdminRights;

@end
