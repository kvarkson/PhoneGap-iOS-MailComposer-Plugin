//
//  MailComposer.js
//  MailComposer
//
//  Created by Stas Gorodnichenko on 11/10/13.
//  MIT Licensed
//

var MailComposer = {

	resultCallback: null,
	recipients: [],
	ccRecipients: [],
	bccRecipients: [],
	subject: '',
	body: '',
	attachments: [],
	isHtml: false,
    
	showMailComposer: function( callbackSuccess ) {
		var args = {};
		this.resultCallback = callbackSuccess;
		
		if ( typeof(this.recipients) === 'object' && this.recipients.length > 0 ) {
			for ( var i = 0; i < this.recipients.length; i++ ) {
				if ( !this.isValid(this.recipients[i]) ) {
					alert('Email in recipients: ' + this.recipients[i] + ' is invalid!');
					return 0;
				}
			}
			args.toRecipients = this.recipients;
		}

		if ( typeof(this.ccRecipients) === 'object' && this.ccRecipients.length > 0 ) {
			for ( var i = 0; i < this.ccRecipients.length; i++ ) {
				if ( !this.isValid(this.ccRecipients[i]) ) {
					alert('Email in ccRecipients: ' + this.ccRecipients[i] + ' is invalid!');
					return 0;
				}
			}
			args.ccRecipients = this.ccRecipients;
		}

		if ( typeof(this.bccRecipients) === 'object' && this.bccRecipients.length > 0 ) {
			for ( var i = 0; i < this.bccRecipients.length; i++ ) {
				if ( !this.isValid(this.bccRecipients[i]) ) {
					alert('Email in bccRecipients: ' + this.bccRecipients[i] + ' is invalid!');
					return 0;
				}
			}
			args.bccRecipients = this.bccRecipients;
		}

		args.attachments = [];
		if ( typeof(this.attachments) === 'object' && this.attachments.length > 0 ) {
			for ( var i = 0; i < this.attachments.length; i++ ) {
				args.attachments.push(this.attachments[i].replace('file://', ''));
			}
		}
		args.subject = this.subject;
		args.body = this.body;
		args.isHtml = this.isHtml;

	    cordova.exec( null, null, "MailComposer", "showMailComposer", [args] );
	}, 

	_didFinishWithResult: function(res) {
		this.resultCallback(res);
	}, 

	isValid: function(email) {
    
        var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(email);
    },
};