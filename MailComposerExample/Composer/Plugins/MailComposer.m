//
//  MailComposer.m
//  MailComposer
//
//  Created by Alex Shmaliy on 10/10/13.
//  Copyright (c) 2013 ASHM. All rights reserved.
//


#define RETURN_CODE_EMAIL_CANCELLED 0
#define RETURN_CODE_EMAIL_SAVED 1
#define RETURN_CODE_EMAIL_SENT 2
#define RETURN_CODE_EMAIL_FAILED 3
#define RETURN_CODE_EMAIL_NOTSENT 4

#import "MailComposer.h"
#import <MobileCoreServices/MobileCoreServices.h>



@implementation MailComposer
    

- (void) showMailComposer:(CDVInvokedUrlCommand*)command {
    NSDictionary *parameters = [command.arguments objectAtIndex:0];
    [self showEmailComposerWithParameters:parameters];
}


- (void)showEmailComposerWithParameters:(NSDictionary*)parameters {
    MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    
    NSArray *toRecipients = [parameters objectForKey:@"toRecipients"];
	NSArray *ccRecipients = [parameters objectForKey:@"ccRecipients"];
	NSArray *bccRecipients = [parameters objectForKey:@"bccRecipients"];
	NSString *subject = [parameters objectForKey:@"subject"];
	NSString *body = [parameters objectForKey:@"body"];
    NSArray *attachmentPaths = [parameters objectForKey:@"attachments"];
    BOOL isHTML = [[parameters objectForKey:@"isHTML"] boolValue];
    
    if(toRecipients != nil && [toRecipients count] > 0) {
        [mailController setToRecipients: toRecipients];
    }
    
    if(ccRecipients != nil && [toRecipients count] > 0) {
        [mailController setCcRecipients: ccRecipients];
    }
    
    if(bccRecipients != nil && [toRecipients count] > 0) {
        [mailController setBccRecipients: bccRecipients];
    }
    
    if(subject != nil) {
        [mailController setSubject: subject];
    }
    
    if(body != nil) {
        [mailController setMessageBody:body isHTML:isHTML];
    }
    
    @try {
        int counter = 1;
        if (attachmentPaths != nil) {
            for (NSString* path in attachmentPaths) {
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
    if (!extension)
        return nil;
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
			webviewResult =RETURN_CODE_EMAIL_SENT;
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


-(void) returnWithCode:(int)code {
    [self writeJavascript:[NSString stringWithFormat:@"MailComposer._didFinishWithResult(%d);", code]];
}
    


@end