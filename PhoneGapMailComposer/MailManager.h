//
//  MailManager.h
//  Email_Sender_111
//
//  Created by Alex Shmaliy on 10/10/13.
//  Copyright (c) 2013 ASHM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface MailManager : NSObject <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSArray  *recipients;
@property (strong, nonatomic) NSArray  *ccRecipients;
@property (strong, nonatomic) NSArray  *bccRecipients;
@property (strong, nonatomic) NSString *subject;

- (void)setMessageBody:(NSString *)body isHTML:(BOOL)isHTML;
- (void)addAttachmentData:(NSData *)attachment mimeType:(NSString *)mimeType fileName:(NSString *)filename;
- (void)showInViewController:(UIViewController *)aViewController;

@end
