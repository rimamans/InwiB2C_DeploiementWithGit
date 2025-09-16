global class QueueUserService implements vlocity_cmt.VlocityOpenInterface {

    @future
    public static void addUserToQueueFuture(String queueId, String userId) {
        try {
            // Crée une nouvelle instance de GroupMember pour ajouter l'utilisateur à la queue
            GroupMember queueMember = new GroupMember(
                GroupId = queueId,
                UserOrGroupId = userId
            );
            insert queueMember;
        } catch (DmlException e) {
            // Gestion des erreurs DML
            System.debug('Erreur lors de l\'ajout de l\'utilisateur à la file d\'attente : ' + e.getMessage());
        } catch (Exception e) {
            // Gestion des autres erreurs
            System.debug('Erreur inattendue : ' + e.getMessage());
        }
    }

    public Boolean invokeMethod(String methodName, 
                                Map<String, Object> input, 
                                Map<String, Object> outMap, 
                                Map<String, Object> options) {
                                    
        if (methodName.equals('AddUserToQueue')) {
            try {
                // Extraire les valeurs QueueId et UserId
                String queueId = (String) input.get('QueueId');
                String userId = (String) input.get('UserId');
                
                // Vérifie si l'ID de l'utilisateur ou l'ID de la queue est fourni
                if (String.isBlank(queueId) || String.isBlank(userId)) {
                    outMap.put('status', 'L\'ID de la file d\'attente ou de l\'utilisateur est vide ou null.');
                    return false;
                }
                
                // Appelle la méthode future pour ajouter l'utilisateur à la queue
                QueueUserService.addUserToQueueFuture(queueId, userId);
                
                // Confirmation
                outMap.put('status', 'L\'utilisateur sera ajouté à la file d\'attente.');
                
            } catch (Exception e) {
                // Gestion des autres erreurs
                outMap.put('status', 'Erreur inattendue : ' + e.getMessage());
                return false;
            }
        } else {
            // Méthode non trouvée
            outMap.put('status', 'Méthode non trouvée : ' + methodName);
            return false;
        }
        
        return true;
    }
}