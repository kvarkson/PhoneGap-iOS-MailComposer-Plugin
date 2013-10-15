PhoneGap-iOS-MailComposer-Plugin
================================================

PhoneGap plugin for showing Mail Composer View in iOS with predefined fields.

#Installing the plugin

Copy MailComposer.h and MailComposer.m files to your Plugins folder and MailComposer.js file to 'www/js/plugins' folder.

Add js file to your index.html.

    <script type="text/javascript" src="js/plugins/MailComposer.js"></script>

Then add the following code to your config.xml:

	<feature name="MailComposer">
		<param name="ios-package" value="MailComposer" />
		<param name="onload" value="true" />
	</feature>

#Using the plugin

In your js file wherever you need to show Email Composer View for a user you need to simply:

    MailComposer.showMailComposer();

This call will show an empty composer. If you need to add some predefined parameters, like recipients, suject and body just do this:

	MailComposer.recipients = ['user@example.com'];
    MailComposer.subject = 'Subject is here';
    MailComposer.body = 'This is the body';
    MailComposer.showMailComposer();

####All available parameters

* subject: a string representing the subject of the email; can be null
* body: a string representing the email body (could be HTML code, in this case set isHtml to true); can be null
* toRecipients: a js array containing all the email addresses for TO field; can be null/empty
* ccRecipients: a js array containing all the email addresses for CC field; can be null/empty
* bccRecipients: a js array containing all the email addresses for BCC field; can be null/empty
* isHtml: a bool value indicating if the body is HTML or plain text
* attachments: a js array containing all full paths ('file:///var.../yourfile') to the files you want to attach; can be null/empty

You can specify a callback for getting information about sending process:

	MailComposer.showMailComposer(function(result){console.log(result);});

The anonymous function in brackets will return the code of the result. The code is below

####Result codes

* 0: email composition cancelled (cancel button pressed and draft not saved)
* 1: email saved (cancel button pressed but draft saved)
* 2: email sent
* 3: send failed
* 4: email not sent (something wrong happened)

#License

The MIT License

Copyright (c) 2013 Stas Gorodnichenko, Alex Shmaliy

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
