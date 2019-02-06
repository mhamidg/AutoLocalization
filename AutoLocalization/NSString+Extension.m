//
//  NSString+Extension.m
//  AutoLocalization
//
//  Created by Hamid Farooq on 2/5/19.
//  Copyright © 2019 Hamid Farooq. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSString *)urlEncode {
    static NSString *const kDelimitersCharacters = @":#[]@";
    static NSString * const kSubDelimitersCharacters = @"!$&'()*+,;=";
    
    NSMutableCharacterSet *allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kDelimitersCharacters stringByAppendingString:kSubDelimitersCharacters]];
    
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < self.length) {
        NSUInteger length = MIN(self.length - index, batchSize);
        NSRange range = NSMakeRange(index, length);
        
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [self rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [self substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    
    return escaped;
}

- (NSString *)urlDecode {
    return [self stringByRemovingPercentEncoding];
}

- (NSString *)stringByTrimmingWhitespaceCharacterSet {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)stringByTrimmingWhitespaceAndNewlineCharacterSet {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
