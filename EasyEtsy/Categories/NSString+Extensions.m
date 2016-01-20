//
//  NSString+Extensions.m
//  EasyEtsy
//
//  Created by Artem Kalinovsky on 20/01/2016.
//  Copyright © 2016 Artem Kalinovsky. All rights reserved.
//

#import "NSString+Extensions.h"
#import "DBGHTMLEntityDecoder.h"

@implementation NSString (Extensions)

+ (NSString *)decodedStringFromString:(NSString *)string {
    DBGHTMLEntityDecoder *decoder = [[DBGHTMLEntityDecoder alloc] init];
    return [decoder decodeString:string];
}

@end
