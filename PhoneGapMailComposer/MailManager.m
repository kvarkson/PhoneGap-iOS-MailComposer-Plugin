//
//  MailManager.m
//  Email_Sender_111
//
//  Created by Alex Shmaliy on 10/10/13.
//  Copyright (c) 2013 ASHM. All rights reserved.
//

#import "MailManager.h"

@interface MailManager()
@property (strong, nonatomic) MFMailComposeViewController *mailController;
@end

@implementation MailManager
@synthesize recipients, ccRecipients, bccRecipients, subject, mailController;

// initialization
- (id)init {
    if (self = [super init]) {
        self.mailController = [[MFMailComposeViewController alloc] init];
        self.mailController.mailComposeDelegate = self;
    }
    return self;
}

// set params
- (void)setSubject:(NSString *)aSubject {
    [self.mailController setSubject:aSubject];
}

- (void)setMessageBody:(NSString *)body isHTML:(BOOL)isHTML {
    [self.mailController setMessageBody:body isHTML:isHTML];
}

- (void)setRecipients:(NSArray *)aRecipients {
    if ([self isValidRecipientsArray:aRecipients]) {
        [self.mailController setToRecipients:aRecipients];
    }
}

- (void)setCcRecipients:(NSArray *)aCcRecipients {
    if ([self isValidRecipientsArray:aCcRecipients]) {
        [self.mailController setCcRecipients:aCcRecipients];
    }
}

- (void)setBccRecipients:(NSArray *)aBccRecipients {
    if ([self isValidRecipientsArray:aBccRecipients]) {
        [self.mailController setBccRecipients:aBccRecipients];
    }
}

// attachments
- (void)addAttachmentData:(NSData *)attachment mimeType:(NSString *)mimeType fileName:(NSString *)filename {
    if (attachment.length && mimeType.length && filename.length) {
        [self.mailController addAttachmentData:attachment mimeType:mimeType fileName:filename];
    }
}

// displaying
- (void)showInViewController:(UIViewController *)aViewController {
    [aViewController presentViewController:self.mailController animated:YES completion:nil];
}

// utils
// TODO: check if this method should be used
- (BOOL)isValidRecipientsArray:(NSArray *)aRecipients {
    BOOL isValid = YES;
    if ([aRecipients count]) {
        for (id anObject in aRecipients) {
            if (![anObject isKindOfClass:[NSString class]]) {
                isValid = NO;
                break;
            }
        }
    }
    else {
        isValid = NO;
    }
    return isValid;
}

#pragma mark MFMailComposeViewController delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
