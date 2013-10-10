//
//  ViewController.m
//  Email_Sender_111
//
//  Created by Alex Shmaliy on 10/10/13.
//  Copyright (c) 2013 ASHM. All rights reserved.
//

#import "ViewController.h"
#import "MailManager.h"

@interface ViewController ()
@property (strong, nonatomic) MailManager *manager;
@end

@implementation ViewController
@synthesize manager;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMail:(id)sender {
    self.manager = [[MailManager alloc] init];
    manager.subject = @"subject 123";
    [manager setMessageBody:@"body 123" isHTML:NO];
    manager.recipients = @[@"aaa@email.com", @"bbb@ututu.net"];
    manager.ccRecipients = @[@"ccc@email.com", @"ddd@ututu.net"];
    manager.bccRecipients = @[@"eee@email.com", @"fff@ututu.net"];
    
    // add image
    NSData *attachmentData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image001" ofType:@"jpg"]];
    [manager addAttachmentData:attachmentData mimeType:@"image/jpeg" fileName:@"image001.jpg"];
    
    // add text
    NSData *attachmentData_2 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"some_text" ofType:@"txt"]];
    [manager addAttachmentData:attachmentData_2 mimeType:@"text/plain" fileName:@"some_text.txt"];
    [manager showInViewController:self];
}

@end
