/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-26-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class InwiB2C_ListViewsD2D {
    @AuraEnabled(cacheable=true)
    public static List<order> getOrdersForUserQueue() {
            // Récupérer l'ID de l'utilisateur connecté
            Id currentUserId = UserInfo.getUserId();
            
            // Trouver les Queues auxquelles appartient cet utilisateur
        /* chb 29/01/2025 BEGIN */
            /*List<GroupMember> userGroups = [
                SELECT GroupId 
                FROM GroupMember 
                WHERE UserOrGroupId = :currentUserId
            ];  */
        //recuperation de la queue depuis agence d'utilisateur connecté
            List<user> userL = [SELECT id , Contact.Account.InwiB2C_Queue__c 
                                FROM user 
                                WHERE id =:currentUserId];
            //recuperation de l'id queue de l'agence
            List<Order> orders =new List<Order>(); // decalaration globale
          if (userL[0].Contact.Account.InwiB2C_Queue__c != null){
                List<group> queueL=[ select Id 
                            FROM group 
                            WHERE DeveloperName =:userL[0].Contact.Account.InwiB2C_Queue__c];

            orders = [
                    SELECT Id, OrderNumber, Name, inwiB2C_Animateur_D2D__r.Name, CreatedDate, 
                        inwiB2C_Statut__c,InwB2C_Statut_livraison_D2D__c,inwib2c_Partenaire__r.inwib2c_CodePartenaire__c, inwib2c_TypeDeLaCommande__c, InwiB2C_Type_Offer__c, 
                        InwiB2C_Offre__c,AccountId,Account.Name, TotalAmount, OwnerId
                    FROM Order 
                    WHERE OwnerId =: queueL[0].Id 
                    ORDER BY CreatedDate DESC limit 2000
                ];
                if (orders.isEmpty()) {
                    orders = new List<Order>();
                }
         }
            
            // Extraire les IDs des Queues
        /*    Set<Id> queueIds = new Set<Id>();
            for (GroupMember gm : userGroups) {
                queueIds.add(gm.GroupId);
            }*/
            /* chb 29/01/2025 END */
            // Récupérer les commandes où le propriétaire est une Queue
        

            // Récupérer les valeurs des statuts et types de commande
            Map<String, String> statutLabels = new Map<String, String>();
            Map<String, String> typeCommandeLabels = new Map<String, String>();
            Map<String, String> Statut_livraison_D2Ds = new Map<String, String>();
            // Récupérer tous les valeurs possibles des statuts et types de commandes dans l'Ordre
            for (Order o : orders) {
                if (o.inwiB2C_Statut__c != null && !statutLabels.containsKey(o.inwiB2C_Statut__c)) {
                    statutLabels.put(o.inwiB2C_Statut__c, getStatutLabel(o.inwiB2C_Statut__c));
                }
                if (o.inwib2c_TypeDeLaCommande__c != null && !typeCommandeLabels.containsKey(o.inwib2c_TypeDeLaCommande__c)) {
                    typeCommandeLabels.put(o.inwib2c_TypeDeLaCommande__c, getTypeCommandeLabel(o.inwib2c_TypeDeLaCommande__c));
                }
                if (o.InwB2C_Statut_livraison_D2D__c != null && !Statut_livraison_D2Ds.containsKey(o.InwB2C_Statut_livraison_D2D__c)) {
                    Statut_livraison_D2Ds.put(o.InwB2C_Statut_livraison_D2D__c, getStatut_livraison_D2DLabel(o.InwB2C_Statut_livraison_D2D__c));
                }
            }

            // Remplacer les API names avec leurs labels dans les résultats
            for (Order o : orders) {
                if (o.inwiB2C_Statut__c != null && statutLabels.containsKey(o.inwiB2C_Statut__c)) {
                    o.put('inwiB2C_Statut__c', statutLabels.get(o.inwiB2C_Statut__c));
                }
                if (o.inwib2c_TypeDeLaCommande__c != null && typeCommandeLabels.containsKey(o.inwib2c_TypeDeLaCommande__c)) {
                    o.put('inwib2c_TypeDeLaCommande__c', typeCommandeLabels.get(o.inwib2c_TypeDeLaCommande__c));
                } if (o.InwB2C_Statut_livraison_D2D__c != null && Statut_livraison_D2Ds.containsKey(o.InwB2C_Statut_livraison_D2D__c)) {
                    o.put('InwB2C_Statut_livraison_D2D__c', Statut_livraison_D2Ds.get(o.InwB2C_Statut_livraison_D2D__c));
                }
            }
            
            return orders;
    }
    @AuraEnabled(cacheable=true)
    public static List<order> getAllOrders() {
            List<Order> orders  = [
                SELECT Id, OrderNumber, Name, inwiB2C_Animateur_D2D__r.Name, CreatedDate, 
                       inwiB2C_Statut__c,InwB2C_Statut_livraison_D2D__c,inwib2c_Partenaire__r.inwib2c_CodePartenaire__c, inwib2c_TypeDeLaCommande__c, InwiB2C_Type_Offer__c, 
                       InwiB2C_Offre__c,AccountId,Account.Name, TotalAmount, OwnerId
                FROM Order 
                ORDER BY CreatedDate DESC limit 2000
            ];
    

        // Récupérer les valeurs des statuts et types de commande
        Map<String, String> statutLabels = new Map<String, String>();
        Map<String, String> typeCommandeLabels = new Map<String, String>();
        Map<String, String> Statut_livraison_D2Ds = new Map<String, String>();
        // Récupérer tous les valeurs possibles des statuts et types de commandes dans l'Ordre
        for (Order o : orders) {
            if (o.inwiB2C_Statut__c != null && !statutLabels.containsKey(o.inwiB2C_Statut__c)) {
                statutLabels.put(o.inwiB2C_Statut__c, getStatutLabel(o.inwiB2C_Statut__c));
            }
            if (o.inwib2c_TypeDeLaCommande__c != null && !typeCommandeLabels.containsKey(o.inwib2c_TypeDeLaCommande__c)) {
                typeCommandeLabels.put(o.inwib2c_TypeDeLaCommande__c, getTypeCommandeLabel(o.inwib2c_TypeDeLaCommande__c));
            }
            if (o.InwB2C_Statut_livraison_D2D__c != null && !Statut_livraison_D2Ds.containsKey(o.InwB2C_Statut_livraison_D2D__c)) {
                Statut_livraison_D2Ds.put(o.InwB2C_Statut_livraison_D2D__c, getStatut_livraison_D2DLabel(o.InwB2C_Statut_livraison_D2D__c));
            }
        }

        // Remplacer les API names avec leurs labels dans les résultats
        for (Order o : orders) {
            if (o.inwiB2C_Statut__c != null && statutLabels.containsKey(o.inwiB2C_Statut__c)) {
                o.put('inwiB2C_Statut__c', statutLabels.get(o.inwiB2C_Statut__c));
            }
            if (o.inwib2c_TypeDeLaCommande__c != null && typeCommandeLabels.containsKey(o.inwib2c_TypeDeLaCommande__c)) {
                o.put('inwib2c_TypeDeLaCommande__c', typeCommandeLabels.get(o.inwib2c_TypeDeLaCommande__c));
            }
            if (o.InwB2C_Statut_livraison_D2D__c != null && Statut_livraison_D2Ds.containsKey(o.InwB2C_Statut_livraison_D2D__c)) {
                o.put('InwB2C_Statut_livraison_D2D__c', Statut_livraison_D2Ds.get(o.InwB2C_Statut_livraison_D2D__c));
            }
        }
        
        return orders;
    }

    // Méthode pour obtenir le label pour 'inwiB2C_Statut__c'
    private static String getStatutLabel(String statutValue) {
        // Remplacer cette logique avec les valeurs réelles ou votre propre logique
        if (statutValue == 'inwiB2C_Activee') {
            return 'Active';  // Label réel
        }else if (statutValue == 'inwiB2C_EnCours') {
            return 'En cours';  // Label réel
        }else if (statutValue == 'inwiB2C_Paiement') {
            return 'Paiement';  // Label réel
        }else if (statutValue == 'inwiB2C_Finalisation') {
            return 'Finalisation';  // Label réel
        }else if (statutValue == 'inwiB2C_Activation') {
            return 'Activation';  // Label réel
        }else if (statutValue == 'inwiB2C_Annulee') {
            return 'Annulée';  // Label réel
        }else if (statutValue == 'inwiB2C_Conforme') {
            return 'Conforme';  // Label réel
        }else if (statutValue == 'inwiB2C_NonConforme') {
            return 'Non Conforme';  // Label réel
        }else if (statutValue == 'inwiB2C_ValideeBO') {
            return 'Validée BO';  // Label réel
        }else if (statutValue == 'inwiB2C_RefuseeBO') {
            return 'Refusée BO';  // Label réel
        }else if (statutValue == 'inwib2c_Validee_BO_135') {
            return 'Validée BO 135';  // Label réel
        }else if (statutValue == 'inwiB2C_Refusee_BO_135') {
            return 'Refusée BO 135';  // Label réel
        }else if (statutValue == 'En attente d\'approbation') {
            return 'En attente d\'approbation';  // Label réel
        }else if (statutValue == 'inwiB2C_Recyclee') {
            return 'Recyclée';  // Label réel
        }else if (statutValue == 'inwiB2C_A_Recycler') {
            return 'A Recycler'; // Label réel
        }
        // Ajoutez d'autres valeurs et labels si nécessaire
        return statutValue; // Retourne le nom de l'API si aucune correspondance
    }

    // Méthode pour obtenir le label pour 'inwib2c_TypeDeLaCommande__c'
    private static String getTypeCommandeLabel(String typeCommandeValue) {
        // Remplacer cette logique avec les valeurs réelles ou votre propre logique
        if (typeCommandeValue == 'inwiB2C_Acquisition') {
            return 'Acquisition';  // Label réel
        }else if(typeCommandeValue =='inwiB2C_Migration'){
             return 'Migration';  // Label réel
        }
        // Ajoutez d'autres valeurs et labels si nécessaire
        return typeCommandeValue; // Retourne le nom de l'API si aucune correspondance
    }
    private static String getStatut_livraison_D2DLabel(String Statut_livraison_D2D) {
        // Remplacer cette logique avec les valeurs réelles ou votre propre logique
        if (Statut_livraison_D2D == 'Inwib2c_CommandeEnVerification') {
            return 'Commande en vérification';  // Label réel
        }else if(Statut_livraison_D2D =='Inwib2c_Commande_A_Livrer'){
             return 'Commande à livrer';  // Label réel
        }else if(Statut_livraison_D2D =='inwiB2C_Commande_livrée'){
            return 'Commande livrée';  // Label réel
       }else if(Statut_livraison_D2D =='Inwib2c_LivraisonAnnulée'){
        return 'Livraison annulée';  // Label réel
   }
        // Ajoutez d'autres valeurs et labels si nécessaire
        return Statut_livraison_D2D; // Retourne le nom de l'API si aucune correspondance
    }
}