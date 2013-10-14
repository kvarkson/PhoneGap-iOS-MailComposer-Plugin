//
//  MailComposer.h
//  MailComposer
//
//  Created by Alex Shmaliy on 10/10/13.
//  Copyright (c) 2013 ASHM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <Cordova/CDVPlugin.h>

@interface MailComposer : CDVPlugin <MFMailComposeViewControllerDelegate>

- (NSString *)getMimeTypeFromFileExtension:(NSString *)extension;
- (void)returnWithCode:(int)code;
- (void)showMailComposer:(CDVInvokedUrlCommand *)command;
    
@end