//
//  LanguageJSONModel.m
//  AutoLocalization
//
//  Created by Hamid Farooq on 2/5/19.
//  Copyright © 2019 Hamid Farooq. All rights reserved.
//

#import "LanguageJSONModel.h"
#import "NSString+Extension.h"

@implementation LanguageJSONModel

- (NSString *)string {
    NSString *string = [[self.rightString stringByTrimmingWhitespaceCharacterSet] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return [string substringToIndex:string.length -1];
}

- (void)setTranslatedString:(NSString *)string {
    self.rightString = [self.rightString stringByReplacingOccurrencesOfString:self.string withString:string];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ = %@", self.leftString, self.rightString];
}

@end
