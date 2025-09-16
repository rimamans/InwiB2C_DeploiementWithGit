var softphone_connector_initialized = false;
function networkError(message) {
    log.error(message);
}
function onIdentity(message) {
}
function onConnectedSession(message) {
    if (softphone_connector_initialized == true) {
        return;
    }
    sfutil.updateOpenCtiStatus(false);
    sfutil.updateConnectionLed("led-yellow", "Connection in standby ...");
}
function onDisconnectedSession(message) {
    $("#led").removeClass();
    $("#led").addClass("led-red");
    $(".led-msg p").text("Session disconnected");
    sfutil.updateOpenCtiStatus(false);
    softphone_connector_initialized = false;
}
function onActivateSession(message) {
    logsf.info("onActivateSession ", message);
    if (softphone_connector_initialized == true) {
        return;
    }
    sfutil.updateConnectionLed("led-green", "Connection estabilished");
    sfutil.updateOpenCtiStatus(true);
    sfutil.enableClickToDial();
    sfutil.addTabFocusListener();
    softphone_connector_initialized = true;
}
function onPostActivateSession(message) {
}
function onDeactivateSession(message) {
}
function onChannelStatus(message) {
    logsf.info("onChannelStatus : ", message);
}
function onEventAgentNotReady(message) {
    logsf.info("onEventAgentNotReady : ", message);
}
function onEventAgentNotReadyAfterCallWork(message) {
}
function onEventAgentReady(message) {
    logsf.info("onEventAgentReady : ", message);
}
function onEventAgentLogout(message) {
}
function onEventAgentLogin(message) {
}
function onEventRingingInbound(message) {
    var callback = function (response) {
        if (response.success) {
            logsf.info('API method call executed successfully! returnValue:', response.returnValue);
        }
        else {
            console.error('Something went wrong! Errors:', response.errors);
        }
    };
    if (iwscore.getLayoutParams().integrationType === 'wwe' || iwscore.getLayoutParams().integrationType === 'pure-embeddable') {
        sforce.opencti.setSoftphonePanelVisibility({ visible: true, callback: callback });
    }
}
function onEventRingingInternal(message) {
}
function onEventRingingConsult(message) {
}
function onEventRingingOutbound(message) {
}

function onEventPartyChangedInbound(message) {
}
function onEventPartyChangedOutbound(message) {
}
function onEventEstablishedInternal(message) {
}
function onEventEstablishedConsult(message) {
}

function onEventHeldInbound(message) {
}
function onEventHeldInternal(message) {
}
function onEventHeldConsult(message) {
}
function onEventHeldOutbound(message) {
}
function onEventRetrievedInbound(message) {
}
function onEventRetrievedInternal(message) {
}
function onEventRetrievedConsult(message) {
}
function onEventRetrievedOutbound(message) {
}

function onEventAttachedDataChangedInternal(message) {
}
function onEventAttachedDataChangedConsult(message) {
}
function onEventAttachedDataChangedOutbound(message) {
}
function onEventReleasedInbound(message) {
}
function onEventReleasedInternal(message) {
}
function onEventReleasedConsult(message) {
}
function onEventReleasedOutbound(message) {
}
function onEventDialingInternal(message) {
}
function onEventDialingConsult(message) {
}
function onEventDialingOutbound(message) {
}
/*function onChatEventRingingInbound(message) {
    	    sfutil.screenpop(message.attachdata.MDN); 

    var callback = function (response) {
        if (response.success) {
            logsf.info('API method call executed successfully! returnValue:', response.returnValue);
        }
        else {
            console.error('Something went wrong! Errors:', response.errors);
        }
    };
    var isVisibleCallback = function (response) {
        if (response.success) {
            if (!response.returnValue.visible) {
                sforce.opencti.setSoftphonePanelVisibility({ visible: true, callback: callback });
            }
            else {
                logsf.info('Softphone Panel is open: ', response.returnValue.visible);
            }
        }
        else {
            console.error('Something went wrong! Errors:', response.errors);
        }
    };
    if (iwscore.getLayoutParams().integrationType === 'wwe' || iwscore.getLayoutParams().integrationType === 'pure-embeddable') {
        sforce.opencti.isSoftphonePanelVisible({ callback: isVisibleCallback });
    }
}*/
function onChatEventRingingConsult(message) {
}

function onChatEventEstablishedConsult(message) {
}
function onChatEventReleasedInbound(message) {
}
function onChatEventReleasedConsult(message) {
}
/*function onChatEventMarkDoneInbound(message) {
    logsf.info("onChatEventMarkDoneInbound , message : ", message);
}*/
function onChatEventTranscriptLink(message) {
}
function onChatEventPartyRemovedInbound(message) {
}
function onChatEventPartyAddedInbound(message) {
}
function onChatEventPartyChangedInbound(message) {
}
function onEmailEventRingingInbound(message) {
}

function onEmailEventReleasedInbound(message) {
}

function onEmailEventReplyReleased(message) {
}
function onEmailEventReplyCancelled(message) {
}

function onDelegateCommand(message) {
}
function onRegisterCommand(message) {
}
function onInhibitCommand(message) {
}
function onWdeSwitchInteraction(message) {
    logsf.info("Called onWdeSwitchInteraction: ", message);
    let id = message.ConnectionID || message.InteractionID;
    if (!id) {
        logsf.info("interaction id null... returning");
        return;
    }
    var event = iwscore.mapInteractions[id.toLowerCase()];
    if (event) {
        sfutil.manageSwitchInteraction(event);
    }
}
function onSwitchInteractionInbound(message) {
    log.debug("Called onSwitchInteractionInbound ");
    onSwitchInteraction(message);
}
function onSwitchInteractionPEF(message) {
    log.debug("Called onSwitchInteractionInbound ");
    logsf.info("Called onSwitchInteractionInbound: ", message);
    onWdeSwitchInteraction(message);
}
function onSwitchInteraction(message) {
    log.debug("Called onWdeSwitchInteraction: " + message);
    sfutil.checkExists(message);
}
function onWorkitemEventEstablishedInbound(message) {
    log.debug("Called onWorkitemEventEstablishedInbound: ");
    logsf.info(message);
}
function onWorkitemEventMarkDoneInbound(message) {
    logsf.info("Called onWorkitemEventMarkDoneInbound: ", message.attachdata);
}
function onWorkitemEventRingingInbound(message) {
    log.debug("Called onWorkitemEventRingingInbound: ");
}


function onEventAttachedDataChangedInbound(message) {
	        logsf.info("onEventAttachedDataChangedInbound ", message);
}
function onEmailEventSessionInfo(message) {
	    logsf.info("onEmailEventSessionInfo , message : ", message.attachdata.CreateCase);
        logsf.info("onEmailEventSessionInfo , message : ", message.InteractionID);
}



/////Voice////
function onEventEstablishedInbound(message) {
	    sfutil.screenpop(message.attachdata.ani);
	    logsf.info("onEventEstablishedInbound, ConnectionID: ", message.ConnectionID);
        logsf.info("onEventEstablishedInbound, Phone Number: ", message.attachdata.ani);
	try {   
	      //logsf.info("Phone Number :", message.ANI.replace("tel:", ""));
            ConnectorEntityController.GetAccountId(message.attachdata.ani, function (result, req) {
            sfutil.publishCTIInformation(message.ConnectionID, message.attachdata.ani, "Voice Inbound", "", "", "", result);
          //sfutil.createTask(message, 'Phone', message.attachdata.MDN, message.MediaType + " - " + message.ConnectionID || message.callId);
            }); 
    }
	catch(err) {
         logsf.info("onEventEstablishedInbound, message :  ERROR in execution of function", err.message);
		 logsf.info("onEventEstablishedInbound, Cannot Create Object Interaction :  ", err.message);
	}
}

function onOutboundNewEventSessionInfo(message) {
	    sfutil.screenpop(message.attachdata.GSW_PHONE); 
	    logsf.info("onOutboundNewEventSessionInfo, ConnectionID: ", message.ConnectionID);
        logsf.info("onOutboundNewEventSessionInfo, Phone Number: ", message.ANI);
	try {   
	      //logsf.info("Phone Number :", message.ANI.replace("tel:", ""));
            ConnectorEntityController.GetAccountId(message.attachdata.GSW_PHONE, function (result, req) {
            sfutil.publishCTIInformation(message.ConnectionID, message.attachdata.GSW_PHONE, "Voice Outbound", "", "", "", result);
        });
    }
	catch(err) {
         logsf.info("onOutboundNewEventSessionInfo, message :  ERROR in execution of function", err.message);
		 logsf.info("onOutboundNewEventSessionInfo, Cannot Create Object Interaction :  ", err.message);
	}
}

function onEventEstablishedConsult(message) {
	    sfutil.screenpop(message.attachdata.ani); 
	    logsf.info("onEventEstablishedConsult, ConnectionID: ", message.ConnectionID);
        logsf.info("onEventEstablishedConsult, Phone Number: ", message.attachdata.ani);
	try {   
	      //logsf.info("Phone Number :", message.attachdata.ani.replace("tel:", ""));
            ConnectorEntityController.GetAccountId(message.attachdata.ani, function (result, req) {
            sfutil.publishCTIInformation(message.ConnectionID, message.attachdata.ani, "Voice Inbound", "", "", "", result);
        });
    }
	catch(err) {
         logsf.info("onEventEstablishedConsult, message :  ERROR in execution of function", err.message);
		 logsf.info("onEventEstablishedConsult, Cannot Create Object Interaction :  ", err.message);
	}
}


/////chat////
function onChatEventEstablishedInbound(message) {
	    sfutil.screenpop(message.attachdata.mdn); 
	    logsf.info("onChatEventEstablishedInbound, ConnectionID: ", message.ConnectionID);
        logsf.info("onChatEventEstablishedInbound, Phone Number: ", message.attachdata.mdn);
	try {   
	      //logsf.info("Phone Number :", message.ANI.replace("tel:", ""));
            ConnectorEntityController.GetAccountId(message.attachdata.mdn, function (result, req) {
            sfutil.publishCTIInformation(message.ConnectionID, message.attachdata.mdn, "Chat", "", "", "", result);
        });
    }
	catch(err) {
         logsf.info("onChatEventEstablishedInbound, message :  ERROR in execution of function", err.message);
		 logsf.info("onChatEventEstablishedInbound, Cannot Create Object Interaction :  ", err.message);
	}
}
function onChatEventOpenedInbound(message) {
  	    sfutil.screenpop(message.attachdata.mdn); 
	    logsf.info("onChatEventOpenedInbound, ConnectionID: ", message.ConnectionID);
        logsf.info("onChatEventOpenedInbound, Phone Number: ", message.attachdata.mdn);
	try {   
	   //  logsf.info("Phone Number :", message.ANI.replace("tel:", ""));
            ConnectorEntityController.GetAccountId(message.attachdata.mdn, function (result, req) {
            sfutil.publishCTIInformation(message.ConnectionID, message.attachdata.mdn, "Chat", "", "", "", result);
        });
    }
	catch(err) {
         logsf.info("onChatEventOpenedInbound, message :  ERROR in execution of function", err.message);
		 logsf.info("onChatEventOpenedInbound, Cannot Create Object Interaction :  ", err.message);
	}
}
function onChatEventPartyRemovedInbound(message) {
}


/////WhatsAppsession////
function onWhatsappsessionEventEstablishedInbound(message) {
        sfutil.screenpop(message.attachdata.mdn); 
	    logsf.info("onWhatsappsessionEventEstablishedInbound, ConnectionID: ", message.ConnectionID);
        logsf.info("onWhatsappsessionEventEstablishedInbound, Phone Number: ", message.attachdata.mdn);
	try {   
	        ConnectorEntityController.GetAccountId(message.attachdata.mdn, function (result, req) {
            sfutil.publishCTIInformation(message.ConnectionID, message.attachdata.mdn, "WhatsAppsession", "", "", "", result);       
            });
    }
	catch(err) {
         logsf.info("onWhatsappsessionEventEstablishedInbound, message :  ERROR in execution of function", err.message);
		 logsf.info("onWhatsappsessionEventEstablishedInbound, Cannot Create Object Interaction :  ", err.message);        
	}
}
function onWhatsappsessionEventOpenedInbound(message) {
        sfutil.screenpop(message.attachdata.mdn); 
	    logsf.info("onWhatsappsessionEventOpenedInbound, ConnectionID: ", message.ConnectionID);
        logsf.info("onWhatsappsessionEventOpenedInbound, Phone Number: ", message.attachdata.mdn);
	try {   
            ConnectorEntityController.GetAccountId(message.attachdata.mdn, function (result, req) {
            sfutil.publishCTIInformation(message.ConnectionID, message.attachdata.mdn, "WhatsAppsession", "", "", "", result);       
            });
    }
	catch(err) {
         logsf.info("onWhatsappsessionEventOpenedInbound, message :  ERROR in execution of function", err.message);
		 logsf.info("onWhatsappsessionEventOpenedInbound, Cannot Create Object Interaction :  ", err.message);
	}
}
function onWhatsAppsessionEventPartyRemovedInbound(message) {

}


/////Email////
function onEmailEventEstablishedInbound(message) {
	    logsf.info("onEmailEventEstablishedInbound, ConnectionID: ", message.ConnectionID);
        logsf.info("onEmailEventEstablishedInbound, EmailAddress: ", message.attachdata.EmailAddress);
	try {   
            ConnectorEntityController.GetAccountId("", function (result, req) {
            sfutil.publishCTIInformation(message.ConnectionID, "", "Email Inbound", message.attachdata.EmailAddress, "", "", result);
        });
    }
	catch(err) {
         logsf.info("onEmailEventEstablishedInbound, message :  ERROR in execution of function", err.message);
		 logsf.info("onEmailEventEstablishedInbound, Cannot Create Object Interaction :  ", err.message);
	}
}

function onEmailEventOpenedInbound(message) {
	    logsf.info("onEmailEventOpenedInbound, ConnectionID: ", message.ConnectionID);
        logsf.info("onEmailEventOpenedInbound, EmailAddress: ", message.attachdata.EmailAddress);
	try {   
            ConnectorEntityController.GetAccountId("", function (result, req) {
            sfutil.publishCTIInformation(message.ConnectionID, "", "Email Inbound", message.attachdata.EmailAddress, "", "", result);
        });
    }
	catch(err) {
         logsf.info("onEmailEventOpenedInbound, message :  ERROR in execution of function", err.message);
		 logsf.info("onEmailEventOpenedInbound, Cannot Create Object Interaction :  ", err.message);
	}
}

function onEmailEventReplyEstablishedOutbound(message) {
	    logsf.info("onEmailEventReplyEstablishedOutbound, ConnectionID: ", message.ConnectionID);
        logsf.info("onEmailEventReplyEstablishedOutbound, EmailAddress: ", message.attachdata.EmailAddress);
	try {   
            ConnectorEntityController.GetAccountId("", function (result, req) {
            sfutil.publishCTIInformation(message.ConnectionID, "", "Email Outbound", message.attachdata.EmailAddress, "", "", result);
        });
    }
	catch(err) {
         logsf.info("onEmailEventReplyEstablishedOutbound, message :  ERROR in execution of function", err.message);
		 logsf.info("onEmailEventReplyEstablishedOutbound, Cannot Create Object Interaction :  ", err.message);
	}
}


/*function onEmailEventEstablishedOutbound(message) {
    logsf.info("onEmailEventEstablishedInbound , EVENT IN : ", message.EVENT);
    logsf.info("onEmailEventEstablishedInbound , InteractionId IN : ", message.InteractionID);
    logsf.info("onEmailEventEstablishedInbound , ParentId IN : ", message.EntrepriseInteractionCurrent.ParentID);
    logsf.info("onEmailEventEstablishedInbound , ThreadID IN : ", message.EntrepriseInteractionCurrent.ThreadID);
    if(message.attachdata.CRMSRC=='SFB2B'){
    logsf.info("onEmailEventEstablishedInbound , message : ", message);
	try {   
	logsf.info("Email Address : ", message.attachdata.EmailAddress);
    logsf.info("Phone Number : ", message.attachdata.ANI);
    }
	catch(err) {
		logsf.info("onEmailEventEstablishedInbound , message :  ERROR in execution of function", err.message);
	}   
}
}*/


/////Twitter////
function onTwitterEventEstablishedInbound(message) {
	    logsf.info("onTwitterEventEstablishedInbound, ConnectionID: ", message.ConnectionID);
        logsf.info("onTwitterEventEstablishedInbound, _twitterFromUserId: ", message.attachdata._twitterFromUserId);
	try {   
            ConnectorEntityController.GetAccountId("", function (result, req) {
            sfutil.publishCTIInformation(message.ConnectionID, "", "Twitter", "", "", message.attachdata._twitterFromUserId, result);
        }); 
    }
	catch(err) {
         logsf.info("onTwitterEventEstablishedInbound, message :  ERROR in execution of function", err.message);
		 logsf.info("onTwitterEventEstablishedInbound, Cannot Create Object Interaction :  ", err.message);
	}
}


function onTwitterEventOpenedInbound(message) {
	    logsf.info("onTwitterEventOpenedInbound, ConnectionID: ", message.ConnectionID);
        logsf.info("onTwitterEventOpenedInbound, _twitterFromUserId: ", message.attachdata._twitterFromUserId);
	try {   
            ConnectorEntityController.GetAccountId("", function (result, req) {
            sfutil.publishCTIInformation(message.ConnectionID, "", "Twitter", "", "", message.attachdata._twitterFromUserId, result);
        });
    }
	catch(err) {
         logsf.info("onTwitterEventOpenedInbound, message :  ERROR in execution of function", err.message);
		 logsf.info("onTwitterEventOpenedInbound, Cannot Create Object Interaction :  ", err.message);
	}
}


function onTwitterEventPartyRemovedInbound(message) {
	
}


/////TwitterDirect////
function onTwitterdirectEventEstablishedInbound(message) {
	    logsf.info("onTwitterdirectEventEstablishedInbound, ConnectionID: ", message.ConnectionID);
        logsf.info("onTwitterdirectEventEstablishedInbound, _twitterFromUserId: ", message.attachdata._twitterFromUserId);
	try {   
            ConnectorEntityController.GetAccountId("", function (result, req) {
            sfutil.publishCTIInformation(message.ConnectionID, "", "Twitter Direct", "", "", message.attachdata._twitterFromUserId, result);
        });
    }
	catch(err) {
         logsf.info("onTwitterdirectEventEstablishedInbound, message :  ERROR in execution of function", err.message);
		 logsf.info("onTwitterdirectEventEstablishedInbound, Cannot Create Object Interaction :  ", err.message);
	}
}
function onTwitterdirectEventOpenedInbound(message) {
	    logsf.info("onTwitterdirectEventOpenedInbound, ConnectionID: ", message.ConnectionID);
        logsf.info("onTwitterdirectEventEstablishedInbound, _twitterFromUserId: ", message.attachdata._twitterFromUserId);
	try {   
            ConnectorEntityController.GetAccountId("", function (result, req) {
            sfutil.publishCTIInformation(message.ConnectionID, "", "Twitter Direct", "", "", message.attachdata._twitterFromUserId, result);
        }); 
    }
	catch(err) {
         logsf.info("onTwitterdirectEventOpenedInbound, message :  ERROR in execution of function", err.message);
		 logsf.info("onTwitterdirectEventOpenedInbound, Cannot Create Object Interaction :  ", err.message);
	}
}
function onTwitterDirectEventPartyRemovedInbound(message) {
	
}


/////Facebook////
function onFacebookEventEstablishedInbound(message) {
	    logsf.info("onFacebookEventEstablishedInbound, ConnectionID: ", message.ConnectionID);
        logsf.info("onFacebookEventEstablishedInbound, _facebookActorId: ", message.attachdata._facebookActorId);
	try {   
            ConnectorEntityController.GetAccountId("", function (result, req) {
            sfutil.publishCTIInformation(message.ConnectionID, "", "Facebook", "", message.attachdata._facebookActorId, "", result);
        });
    }
	catch(err) {
         logsf.info("onFacebookEventEstablishedInbound, message :  ERROR in execution of function", err.message);
		 logsf.info("onFacebookEventEstablishedInbound, Cannot Create Object Interaction :  ", err.message);
	}
}
function onFacebookEventOpenedInbound(message) {
	    logsf.info("onFacebookEventOpenedInbound, ConnectionID: ", message.ConnectionID);
        logsf.info("onFacebookEventOpenedInbound, _facebookActorId: ", message.attachdata._facebookActorId);
	try {   
            ConnectorEntityController.GetAccountId("", function (result, req) {
            sfutil.publishCTIInformation(message.ConnectionID, "", "Facebook", "", message.attachdata._facebookActorId, "", result);
        });
    }
	catch(err) {
         logsf.info("onFacebookEventOpenedInbound, message :  ERROR in execution of function", err.message);
		 logsf.info("onFacebookEventOpenedInbound, Cannot Create Object Interaction :  ", err.message);
	}
}
function onFacebookEventPartyRemovedInbound(message) {
	
}

/////Facebooksession////
function onFacebooksessionmodeEventEstablishedInbound(message) {
	    logsf.info("onFacebooksessionmodeEventEstablishedInbound, ConnectionID: ", message.ConnectionID);
        logsf.info("onFacebooksessionmodeEventEstablishedInbound, _facebookActorId: ", message.attachdata._facebookActorId);
	try {   
            ConnectorEntityController.GetAccountId("", function (result, req) {
            sfutil.publishCTIInformation(message.ConnectionID, "", "Facebooksession", "", message.attachdata._facebookActorId, "", result);
        });
    }
	catch(err) {
         logsf.info("onFacebooksessionmodeEventEstablishedInbound, message :  ERROR in execution of function", err.message);
		 logsf.info("onFacebooksessionmodeEventEstablishedInbound, Cannot Create Object Interaction :  ", err.message);
	}
}
function onFacebooksessionmodeEventOpenedInbound(message) {
	    logsf.info("onFacebooksessionmodeEventOpenedInbound, ConnectionID: ", message.ConnectionID);
        logsf.info("onFacebooksessionmodeEventOpenedInbound, _facebookActorId: ", message.attachdata._facebookActorId);
	try {   
            ConnectorEntityController.GetAccountId("", function (result, req) {
            sfutil.publishCTIInformation(message.ConnectionID, "", "Facebooksession", "", message.attachdata._facebookActorId, "", result);
        });
    }
	catch(err) {
         logsf.info("onFacebooksessionmodeEventOpenedInbound, message :  ERROR in execution of function", err.message);
		 logsf.info("onFacebooksessionmodeEventOpenedInbound, Cannot Create Object Interaction :  ", err.message);
	}
	
}
function onFacebooksessionmodeEventPartyRemovedInbound(message) {
	
}

/////FacebookPrivateMessage////
function onFacebookprivatemessageEventEstablishedOutbound(message) {
	    logsf.info("onFacebookprivatemessageEventEstablishedOutbound, ConnectionID: ", message.ConnectionID);
        logsf.info("onFacebookprivatemessageEventEstablishedOutbound, _facebookActorId: ", message.attachdata._facebookActorId);
	try {   
            ConnectorEntityController.GetAccountId("", function (result, req) {
            sfutil.publishCTIInformation(message.ConnectionID, "", "FacebookPrivateMessage", "", message.attachdata._facebookActorId, "", result);
        }); 
    }
	catch(err) {
         logsf.info("onFacebookprivatemessageEventEstablishedOutbound, message :  ERROR in execution of function", err.message);
		 logsf.info("onFacebookprivatemessageEventEstablishedOutbound, Cannot Create Object Interaction :  ", err.message);
	}
}
