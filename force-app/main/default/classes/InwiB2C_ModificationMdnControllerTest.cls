@isTest
    public class InwiB2C_ModificationMdnControllerTest {
        @isTest
         public static void Test1() {
          String name = 'test';
          String cin = 'test';
          String mdn = 'test';
          String offre = 'test';
          String poscode = 'test';
          String numcomm = 'test';
          String oldmdn = 'test';
          String newmdn = 'test';
          String fraischan = 'test';
          String datedefacturation = 'test';
          String typeModification = 'test';
          String typeChang = 'NORMAL';
        
          Test.StartTest();
          ApexPages.currentPage().getParameters().put('name',name);
          ApexPages.currentPage().getParameters().put('cin',cin);
          ApexPages.currentPage().getParameters().put('mdn',mdn);
          ApexPages.currentPage().getParameters().put('cin',cin);
          ApexPages.currentPage().getParameters().put('offre',offre);
          ApexPages.currentPage().getParameters().put('poscode',poscode);
          ApexPages.currentPage().getParameters().put('numcomm',numcomm);
          ApexPages.currentPage().getParameters().put('oldmdn',oldmdn);
          ApexPages.currentPage().getParameters().put('newmdn',newmdn);
          ApexPages.currentPage().getParameters().put('categoriemdn',typeChang);
          ApexPages.currentPage().getParameters().put('fraischgtmdn',fraischan);
          ApexPages.currentPage().getParameters().put('datedefacturation',datedefacturation);
          ApexPages.currentPage().getParameters().put('typeModification',typeModification);
           
          InwiB2C_ModificationMdn_Controller ModificationMdnController = new InwiB2C_ModificationMdn_Controller();
                    Test.StopTest();
    
            
        }
       
    
    }