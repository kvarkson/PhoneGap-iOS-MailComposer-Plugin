//
//  MailComposer.m
//  MailComposer
//
//  Created by Alex Shmaliy on 10/10/13.
//  Copyright (c) 2013 ASHM. All rights reserved.
//

#import "MailComposer.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define RETURN_CODE_EMAIL_CANCELLED 0
#define RETURN_CODE_EMAIL_SAVED     1
#define RETURN_CODE_EMAIL_SENT      2
#define RETURN_CODE_EMAIL_FAILED    3
#define RETURN_CODE_EMAIL_NOTSENT   4

#define TO_RECIPIENTS_KEY  @"toRecipients"
#define CC_RECIPIENTS_KEY  @"ccRecipients"
#define BCC_RECIPIENTS_KEY @"bccRecipients"
#define SUBJECT_KEY        @"subject"
#define BODY_KEY           @"body"
#define ATTACHMENTS_KEY    @"attachments"
#define IS_HTML_KEY        @"isHtml"

@implementation MailComposer
    
- (void)showMailComposer:(CDVInvokedUrlCommand *)command {
    if (![MFMailComposeViewController canSendMail]) {
        NSLog(@"Mail not configured");
        UIAlertView *mailNotConfiguredAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please configure your email account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [mailNotConfiguredAlert show];
        return;
    }
    if ([command.arguments count]) {
        NSDictionary *parameters = command.arguments[0];
        [self showEmailComposerWithParameters:parameters];
    } else {
        NSLog(@"warning: missed arguments");
    }
}

- (void)showEmailComposerWithParameters:(NSDictionary *)parameters {
    MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    
    NSArray *toRecipients = parameters[TO_RECIPIENTS_KEY];
    NSArray *ccRecipients = parameters[CC_RECIPIENTS_KEY];
    NSArray *bccRecipients = parameters[BCC_RECIPIENTS_KEY];
    NSString *subject = parameters[SUBJECT_KEY];
    NSString *body = parameters[BODY_KEY];
    NSArray *attachmentPaths = parameters[ATTACHMENTS_KEY];
    BOOL isHTML = [parameters[IS_HTML_KEY] boolValue];
    
    if(toRecipients != nil && [toRecipients count] > 0) {
        [mailController setToRecipients:toRecipients];
    }
    
    if(ccRecipients != nil && [toRecipients count] > 0) {
        [mailController setCcRecipients:ccRecipients];
    }
    
    if(bccRecipients != nil && [toRecipients count] > 0) {
        [mailController setBccRecipients:bccRecipients];
    }
    
    if(subject != nil) {
        [mailController setSubject:subject];
    }
    
    if(body != nil) {
        [mailController setMessageBody:body isHTML:isHTML];
    }
    
    @try {
        int counter = 1;
        if (attachmentPaths) {
            for (NSString *path in attachmentPaths) {
                @try {
                    NSData *data = [NSData dataWithContentsOfFile: path];
                    [mailController addAttachmentData:data mimeType:[self getMimeTypeFromFileExtension:[path pathExtension]] fileName:[NSString stringWithFormat:@"attachment%d.%@", counter, [path pathExtension]]];
                    counter++;
                }
                @catch (NSException *exception) {
                    NSLog(@"Cannot attach file at path %@; error: %@", path, exception);
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"EmailComposer - Cannot set attachments; error: %@", exception);
    }
    
    [self.viewController presentModalViewController:mailController animated:YES];
}
    
    // Retrieve the mime type from the file extension
- (NSString *)getMimeTypeFromFileExtension:(NSString *)extension {
    if (!extension) {
        return nil;
    }
    CFStringRef pathExtension, type;
    // Get the UTI from the file's extension
    pathExtension = (CFStringRef)CFBridgingRetain(extension);
    type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
    
    // Converting UTI to a mime type
    return (NSString *)CFBridgingRelease(UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType));
}
    
#pragma mark MFMailComposeViewController delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    int webviewResult = 0;
    
    switch (result) {
        case MFMailComposeResultCancelled:
        webviewResult = RETURN_CODE_EMAIL_CANCELLED;
        break;
        case MFMailComposeResultSaved:
        webviewResult = RETURN_CODE_EMAIL_SAVED;
        break;
        case MFMailComposeResultSent:
        webviewResult = RETURN_CODE_EMAIL_SENT;
        break;
        case MFMailComposeResultFailed:
        webviewResult = RETURN_CODE_EMAIL_FAILED;
        break;
        default:
        webviewResult = RETURN_CODE_EMAIL_NOTSENT;
        break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self returnWithCode:webviewResult];
}
    
    
- (void)returnWithCode:(int)code {
    [self writeJavascript:[NSString stringWithFormat:@"MailComposer._didFinishWithResult(%d);", code]];
}
    
    @end