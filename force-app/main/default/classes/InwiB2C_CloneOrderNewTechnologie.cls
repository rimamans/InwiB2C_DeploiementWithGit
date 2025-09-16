global without sharing  class InwiB2C_CloneOrderNewTechnologie implements vlocity_cmt.VlocityOpenInterface {

                global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
                    if (methodName == 'CreateOrder') {
                            outMap.put('result', CreateOrder(inputMap));
                        }
                return true;
            }
            
                Map<String,Object> CreateOrder(Map<String,Object> inputMap) {
            
                System.debug('RMA');
            
                String OrderId=(String) inputMap.get('OrderId'); 
            
                System.debug('OrderId' +OrderId);
                List<Order> OrderOriginal= [SELECT Pricebook2Id,InwiB2C_OTP__c,ContractId,InwiB2C_Code_de_transaction_FMS__c,InwiB2C_CodeTransactionFMD__c,inwib2c_AvecPortabilite__c,InwiB2C_Type_Offer__c,InwiB2C_Mode_de_paiement_FMS__c,InwiB2C_FMD_Total__c,Mode_de_paiement_FMD__c,vlocity_cmt__DefaultServiceAccountId__c, vlocity_cmt__FulfilmentStatus__c, vlocity_cmt__IsChangesAllowed__c, vlocity_cmt__PriceListId__c, vlocity_cmt__SubmittedToOmDate__c,inwib2c_TypeDeLaCommande__c,inwib2c_Partenaire__c, inwib2c_Distributeur__c, inwib2c_ModeDePaiement__c, inwiB2C_Statut__c, status, EffectiveDate,inwib2c_ModeDeLivraison__c,AccountId, inwiB2C_Canal__c,vlocity_cmt__CartIdentifier__c,InwiB2C_Offre__c,vlocity_cmt__DefaultBillingAccountId__c,inwib2c_CodeDeTransaction__c from order where id = :OrderId limit 1];



                Order newOrder =  OrderOriginal[0].clone(false, true, false, true);

                newOrder.EffectiveDate = date.today();
                newOrder.AccountId = OrderOriginal[0].AccountId;
                newOrder.ContractId= OrderOriginal[0].ContractId;
                newOrder.vlocity_cmt__DefaultServiceAccountId__c=OrderOriginal[0].vlocity_cmt__DefaultServiceAccountId__c;
                newOrder.InwiB2C_Type_Offer__c = OrderOriginal[0].InwiB2C_Type_Offer__c;
                newOrder.inwib2c_Partenaire__c = OrderOriginal[0].inwib2c_Partenaire__c;
                newOrder.inwib2c_Distributeur__c = OrderOriginal[0].inwib2c_Distributeur__c;
                newOrder.inwib2c_ModeDePaiement__c = OrderOriginal[0].inwib2c_ModeDePaiement__c;
                newOrder.InwiB2C_Mode_de_paiement_FMS__c = OrderOriginal[0].InwiB2C_Mode_de_paiement_FMS__c; 
                newOrder.Mode_de_paiement_FMD__c = OrderOriginal[0].Mode_de_paiement_FMD__c; 
                newOrder.Mode_de_paiement_FMD__c = OrderOriginal[0].Mode_de_paiement_FMD__c;
                newOrder.InwiB2C_Code_de_transaction_FMS__c=OrderOriginal[0].InwiB2C_Code_de_transaction_FMS__c;

                newOrder.InwiB2C_CodeTransactionFMD__c=OrderOriginal[0].InwiB2C_CodeTransactionFMD__c;
                newOrder.inwib2c_AvecPortabilite__c=OrderOriginal[0].inwib2c_AvecPortabilite__c;
                newOrder.InwiB2C_Issue_de_commande_de_technologie__c=true;
                newOrder.inwiB2C_Canal__c= OrderOriginal[0].inwiB2C_Canal__c;
                newOrder.inwib2c_CodeDeTransaction__c = OrderOriginal[0].inwib2c_CodeDeTransaction__c;
                newOrder.InwiB2C_OTP__c = OrderOriginal[0].InwiB2C_OTP__c;

                
                insert newOrder;
                System.debug('NewOrderId' +newOrder.Id);



                List<String> productItemId = new List<String>();
                //clonerOrderItem
            
                List<OrderItem> NewOrderItems= new List<OrderItem>(); 
                List<OrderItem> OrderItemsWhereParentNotNull =[select id, InwiB2C_MDN__c,vlocity_cmt__CatalogItemReferenceDateTime__c, vlocity_cmt__UsageQuantity__c,OrderId, vlocity_cmt__AssetReferenceId__c, Product2Id, Product2.ProductCode, PricebookEntryId, AvailableQuantity, Quantity, CurrencyIsoCode, UnitPrice, ListPrice, TotalPrice, Description, OrderItemNumber, vlocity_cmt__Action__c, vlocity_cmt__BillingAccountId__c, vlocity_cmt__CpqCardinalityMessage__c, vlocity_cmt__CurrencyPaymentMode__c, vlocity_cmt__EffectiveOneTimeLoyaltyTotal__c, vlocity_cmt__EffectiveOneTimeTotal__c, vlocity_cmt__EffectiveQuantity__c, vlocity_cmt__EffectiveRecurringTotal__c, vlocity_cmt__InCartQuantityMap__c, vlocity_cmt__IsEditable__c, vlocity_cmt__IsProductTrackAgreement__c, vlocity_cmt__JSONAttribute__c,  vlocity_cmt__LineNumber__c, vlocity_cmt__MonthlyTotal__c, vlocity_cmt__OneTimeCalculatedPrice__c, vlocity_cmt__OneTimeCharge__c, vlocity_cmt__OneTimeLoyaltyPrice__c, vlocity_cmt__OneTimeLoyaltyTotal__c, vlocity_cmt__OneTimeManualDiscount__c, vlocity_cmt__OneTimeTotal__c, vlocity_cmt__OverageUOM__c, vlocity_cmt__ParentItemId__c, vlocity_cmt__PricingLogData__c, vlocity_cmt__Product2Id__c, vlocity_cmt__ProductHierarchyPath__c, vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringCalculatedPrice__c, vlocity_cmt__RecurringCharge__c,  vlocity_cmt__RecurringManualDiscount__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__RelationshipType__c, vlocity_cmt__RootItemId__c, vlocity_cmt__SequenceNumber__c, vlocity_cmt__ServiceAccountId__c, vlocity_cmt__IsChangesAccepted__c, vlocity_cmt__IsChangesAllowed__c, IsNotAssetizable__c from orderitem where orderid = :OrderId AND vlocity_cmt__ParentItemId__c !=null  limit 20];
                for (OrderItem orderItem : OrderItemsWhereParentNotNull) {
                    productItemId.add(orderItem.Product2Id);
                }
            
                system.debug('Id des Product2: ' +  productItemId);
                List<OrderItem> OrderItemsFromOrderBase =[select id, InwiB2C_MDN__c,InwiB2C_FMS__c,InwiB2C_FMD__c ,vlocity_cmt__CatalogItemReferenceDateTime__c, vlocity_cmt__UsageQuantity__c,OrderId, vlocity_cmt__AssetReferenceId__c, Product2Id, Product2.ProductCode, PricebookEntryId, AvailableQuantity, Quantity, CurrencyIsoCode, UnitPrice, ListPrice, TotalPrice, Description, OrderItemNumber, vlocity_cmt__Action__c, vlocity_cmt__BillingAccountId__c, vlocity_cmt__CpqCardinalityMessage__c, vlocity_cmt__CurrencyPaymentMode__c, vlocity_cmt__EffectiveOneTimeLoyaltyTotal__c, vlocity_cmt__EffectiveOneTimeTotal__c, vlocity_cmt__EffectiveQuantity__c, vlocity_cmt__EffectiveRecurringTotal__c, vlocity_cmt__InCartQuantityMap__c, vlocity_cmt__IsEditable__c, vlocity_cmt__IsProductTrackAgreement__c, vlocity_cmt__JSONAttribute__c,vlocity_cmt__ServiceAccountId__c,  vlocity_cmt__LineNumber__c, vlocity_cmt__MonthlyTotal__c, vlocity_cmt__OneTimeCalculatedPrice__c, vlocity_cmt__OneTimeCharge__c, vlocity_cmt__OneTimeLoyaltyPrice__c, vlocity_cmt__OneTimeLoyaltyTotal__c, vlocity_cmt__OneTimeManualDiscount__c, vlocity_cmt__OneTimeTotal__c, vlocity_cmt__OverageUOM__c, vlocity_cmt__ParentItemId__c, vlocity_cmt__PricingLogData__c, vlocity_cmt__Product2Id__c, vlocity_cmt__ProductHierarchyPath__c, vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringCalculatedPrice__c, vlocity_cmt__RecurringCharge__c,  vlocity_cmt__RecurringManualDiscount__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__RelationshipType__c, vlocity_cmt__RootItemId__c, vlocity_cmt__SequenceNumber__c, vlocity_cmt__IsChangesAccepted__c, vlocity_cmt__IsChangesAllowed__c, IsNotAssetizable__c from orderitem where orderid = :OrderId  limit 20];
                    
                for (OrderItem Item :OrderItemsFromOrderBase){
            
                    Item.vlocity_cmt__IsChangesAllowed__c=true;

            
                }

                update OrderItemsFromOrderBase;
                Map<String,String> ProductCodeByItemIdMap= new Map<String,String>();
                for (OrderItem Item :OrderItemsFromOrderBase){
            
                    ProductCodeByItemIdMap.put(item.id, item.Product2Id);
            
                }




                for (OrderItem Item :OrderItemsFromOrderBase)
                {
                    OrderItem newOrderItem; // = new OrderItem();
                    String parentProductId = ProductCodeByItemIdMap.get(Item.vlocity_cmt__ParentItemId__c);
                    system.debug('Id de Produit Parent: ' +  parentProductId);
                    system.debug('Id de Produit Parent2: ' +  item.Product2Id);
                    vlocity_cmt__ProductChildItem__c childItemDef = new vlocity_cmt__ProductChildItem__c();
                    if (parentProductId != null){
                        childItemDef = [select vlocity_cmt__MinQuantity__c from vlocity_cmt__ProductChildItem__c where vlocity_cmt__ParentProductId__c = :parentProductId and vlocity_cmt__ChildProductId__c  = :Item.Product2Id limit 1];
                    }
                
                    //vlocity_cmt__ProductChildItem__c childItemDef = [SELECT vlocity_cmt__MinQuantity__c FROM vlocity_cmt__ProductChildItem__c WHERE vlocity_cmt__ParentProductId__c = :parentProductId AND vlocity_cmt__ChildProductId__c IN:productItemId LIMIT 1];
            
                    if (Item.vlocity_cmt__ParentItemId__c == null ||  (parentProductId != null && childItemDef.vlocity_cmt__MinQuantity__c == 1) ){
                        newOrderItem = Item.clone(false, true, false, true);
                        newOrderItem.OrderId = newOrder.Id;
                      
                          
                        newOrderItem.vlocity_cmt__AssetReferenceId__c = null;
                        newOrderItem.vlocity_cmt__BillingAccountId__c =  OrderItemsFromOrderBase[0].vlocity_cmt__BillingAccountId__c;
                        newOrderItem.vlocity_cmt__ServiceAccountId__c=OrderItemsFromOrderBase[0].vlocity_cmt__ServiceAccountId__c;
                         // ItemNews.vlocity_cmt__EffectiveRecurringTotal__c = OrderItemsFromOrderBase[0].vlocity_cmt__EffectiveRecurringTotal__c;
                       // ItemNews.vlocity_cmt__EffectiveOneTimeTotal__c = OrderItemsFromOrderBase[0].vlocity_cmt__EffectiveOneTimeTotal__c;

                         
                        NewOrderItems.add(newOrderItem);

                        system.debug('ORDER ITEM : ' + newOrder.Id);
                    }
                
                
                    List<OrderItem> OrderItemsFromOrderNew = [select id,InwiB2C_FMS__c,InwiB2C_FMD__c from OrderItem where OrderId  = :newOrder.Id and vlocity_cmt__ParentItemId__c   = '' limit 1];
                    for (OrderItem ItemNews :OrderItemsFromOrderNew)
                    {
                        ItemNews.InwiB2C_FMS__c = OrderItemsFromOrderBase[0].InwiB2C_FMS__c;
                        ItemNews.InwiB2C_FMD__c = OrderItemsFromOrderBase[0].InwiB2C_FMD__c;
                      
                        NewOrderItems.add(ItemNews);

                }
 
                    
                }
                Insert NewOrderItems;

















                Map<String, Object> result = new Map<String, Object>();

                result.put('NewOrderId', newOrder.Id
                // new Map<String, Object>{
                
                // 'NewOrderId'       => newOrder.Id,
                // 'OrderITem' =>  NewOrderItems
            
            
            // }
            );
            System.debug('Result: ' + result);
            
            return result;










        }
    }