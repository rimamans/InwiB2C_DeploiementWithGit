({
    callUtilityBarApi : function(component,ExeNewOS) {
        const utilityBarAPI = component.find("utilityBarAPI");

        console.log('started');

        utilityBarAPI.getEnclosingUtilityId().then(function (utilityId) {
            console.log("utilityId", utilityId);
        });

        utilityBarAPI.onUtilityClick({
            
            eventHandler: function () {
                utilityBarAPI.minimizeUtility();

                //LDA 20201219 start

                var ctiIteractionNumber = component.get("v.ctiIteractionNumber")||'';
                var ctiSource = component.get("v.ctiSource")||'';
                var ctiEmailSource = component.get("v.ctiEmailSource")||'';
                var ctiFacebookId = component.get("v.ctiFacebookId")||'';
                var ctiTwitterId = component.get("v.ctiTwitterId")||'';
                var vlocityInteractionId = component.get("v.vlocityInteractionId")||'';
                var ctiMDN = component.get("v.ctiMDN")||'';

                var workspaceAPI = component.find("workspace");
                
                /* Old
                workspaceAPI.openTab({
                    url: '#/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c%3Ainwi360SearchAccountFrench',
                    focus: true
                });
                */

                console.log('ctiIteractionNumber 1111: ' + ctiIteractionNumber);


  
            
                var URL;

                console.log('ExeNewOS::'+ExeNewOS)

                if(ExeNewOS)
                    URL = '#/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c%3Ainwi360SearchAnAccountFrench&c__ctiIteractionNumber=' + ctiIteractionNumber;
                else
                    URL = '#/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c%3Ainwi360SearchAnAccountFrench&c__ctiIteractionNumber=' + ctiIteractionNumber;
                
                URL += '&c__ctiSource=' + ctiSource;
                URL += '&c__ctiEmailSource=' + ctiEmailSource;
                URL += '&c__ctiFacebookId=' + ctiFacebookId;
                URL += '&c__ctiTwitterId=' + ctiTwitterId;
                URL += '&c__vlocityInteractionId=' + vlocityInteractionId;
                URL += '&c__ctiMDN=' + ctiMDN;

                //console.log('URL : ' + URL);
                
 
                workspaceAPI.openTab({
                    url: URL ,
                    focus: true
                }).then(function(response){
                    workspaceAPI.setTabLabel({
                        tabId: response,
                        label: "Recherche Personne"
                    });
                });

                console.log("onUtilityClick");
            }
        });
    }
})