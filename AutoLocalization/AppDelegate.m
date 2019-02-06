//
//  AppDelegate.m
//  AutoLocalization
//
//  Created by Hamid Farooq on 2/5/19.
//  Copyright © 2019 Hamid Farooq. All rights reserved.
//

#import "AppDelegate.h"
#import "LanguageJSONModel.h"
#import "NSString+Extension.h"
#import <AFNetworking/AFNetworking.h>

#define kGoogleAPIKey   @"{Google API Key Translation Enabled}"
#define kSourceLanguage @"en" // Source Language identifier
#define kTargetLanguage @"de" // Destination/Translation language identifier

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [self translateLocalizedString:[self stringOfLocalizedFile]];
    
    return YES;
}

- (NSString *)stringOfLocalizedFile {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Localizablestrings" ofType:nil];
    
    NSError *error = nil;
    NSString *localizedString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
        return nil;
    }

    return localizedString;
}

- (void)translateLocalizedString:(NSString *)string {
    if (string == nil)
        return;
    
    NSMutableArray *mutableLines = [[string componentsSeparatedByString:@"\n"] mutableCopy];
    for (int i=0; i<mutableLines.count; i++) {
        NSString *line = mutableLines[i];
        NSArray *components = [line componentsSeparatedByString:@"="];
        if (components.count == 2) {
            LanguageJSONModel *language = [[LanguageJSONModel alloc] init];
            
            language.leftString = components.firstObject;
            language.rightString = components.lastObject;
            
            NSString *translation = [self translationOfString:language.string];
            language.translatedString = translation;
            
            [mutableLines replaceObjectAtIndex:i withObject:language];
        }
        
        NSLog(@"%i / %lu", i, (unsigned long)mutableLines.count);
    }
    
    NSString *localizedString = [mutableLines componentsJoinedByString:@"\n"];
    
    NSURL *path = [self.applicationDocumentsDirectory URLByAppendingPathComponent:@"Localizable.strings"];
    
    NSError *error = nil;
    if ([localizedString writeToURL:path atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
        NSLog(@"File saved at path: %@", path);
        
        [[[UIAlertView alloc] initWithTitle:@"Translation Finished" message:@"Your specified translation language is saved in file. Find the path in logs." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (NSString *)translationOfString:(NSString *)string {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSString *URLString = [NSString stringWithFormat:@"https://www.googleapis.com/language/translate/v2?key=%@&source=%@&target=%@&q=%@", kGoogleAPIKey, kSourceLanguage, kTargetLanguage, string.urlEncode];
    
    NSURL *URL = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    __block NSString *translatedString = nil;
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                         if (error == nil) {
                                             NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                             
                                             if ([responseObject objectForKey:@"data"]) {
                                                 if ([responseObject[@"data"] objectForKey:@"translations"]) {
                                                     NSArray *translations = [responseObject[@"data"] objectForKey:@"translations"];
                                                     for (NSDictionary *translation in translations) {
                                                         translatedString = [translation objectForKey:@"translatedText"];
                                                     }
                                                 }
                                                 else if ([responseObject[@"data"] objectForKey:@"translatedText"]) {
                                                     translatedString = [responseObject[@"data"] objectForKey:@"translatedText"];
                                                 }
                                             }
                                         }
                                         
                                         dispatch_semaphore_signal(semaphore);
                                     }] resume];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return translatedString;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
