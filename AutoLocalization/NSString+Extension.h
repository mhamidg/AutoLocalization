//
//  NSString+Extension.h
//  AutoLocalization
//
//  Created by Hamid Farooq on 2/5/19.
//  Copyright © 2019 Hamid Farooq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (NSString *)urlEncode;

- (NSString *)urlDecode;

- (NSString *)stringByTrimmingWhitespaceCharacterSet;

- (NSString *)stringByTrimmingWhitespaceAndNewlineCharacterSet;

@end
