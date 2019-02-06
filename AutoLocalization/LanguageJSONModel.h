//
//  LanguageJSONModel.h
//  AutoLocalization
//
//  Created by Hamid Farooq on 2/5/19.
//  Copyright © 2019 Hamid Farooq. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface LanguageJSONModel : JSONModel

@property (nonatomic) NSString<Optional> *leftString;
@property (nonatomic) NSString<Optional> *rightString;

@property (nonatomic, readonly) NSString *string;

- (void)setTranslatedString:(NSString *)string;

@end
