/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var fileUrl = '',
    app = {

        initialize: function() {
            this.bindEvents();
        },
        
        bindEvents: function() {
            document.addEventListener('deviceready', this.onDeviceReady, false);
        },
        
        onDeviceReady: function() {
            app.receivedEvent('deviceready');
        },

        takePhoto: function() {
            navigator.camera.getPicture(this.onSuccess, this.onFail, { quality: 50, 
                destinationType: Camera.DestinationType.FILE_URI });
        },

        onSuccess: function(imageURI) {
            fileUrl = imageURI;
        },

        onFail: function(message) {
            alert('Failed because: ' + message);
        },
        
        showMailComposer: function() {
            MailComposer.recipients = ['user@example.com'];
            MailComposer.ccRecipients = ['user1@example.com', 'user2@example.com'];
            MailComposer.bccRecipients = ['user3@example.com', 'user4@example.com'];
            MailComposer.subject = 'Subject is here';
            MailComposer.body = 'This is the body';
            MailComposer.attachments = [fileUrl];
            MailComposer.showMailComposer(function(result){console.log(result);});
        }
};
