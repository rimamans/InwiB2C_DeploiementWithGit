/*ZME*/
public class inwiB2C_AccountEditController {
    public inwiB2C_AccountEditController(ApexPages.StandardController controller) {
        this.controller = controller;
    }
    public PageReference getRedir() {
        PageReference newPage;
        Account acc = [Select id, recordtype.name From Account Where Id = :ApexPages.currentPage().getParameters().get('id')];
        
        if (acc.recordtype.name == 'Consumer') {
            newPage = Page.inwiB2C_AccountEditConsumer;
        } else
            newPage = new PageReference('/' + acc.id +'/e'); 
        newPage.getParameters().put('nooverride', '1');
        newPage.getParameters().put('retURL', ApexPages.currentPage().getParameters().get('retURL'));
        
        if (newPage != null) {
            newPage.getParameters().put('id', acc.id);
        }
        return newPage.setRedirect(true);
    }
    private final ApexPages.StandardController controller;  
}