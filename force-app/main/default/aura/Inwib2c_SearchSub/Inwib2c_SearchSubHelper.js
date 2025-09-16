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


               

                var workspaceAPI = component.find("workspace");
           


  
            
                var URL;


                
                    URL = '#/cmp/vlocity_cmt__vlocityLWCOmniWrapper?c__target=c%3Ainwib2cSearchSubFromCINFrench' ;
                
               

            
                workspaceAPI.openTab({
                    url: URL ,
                    focus: true
                }).then(function(response){
                    workspaceAPI.setTabLabel({
                        tabId: response,
                        label: "Recherche Souscription"
                    });
                });

                console.log("onUtilityClick");
            }
        });
    }
})