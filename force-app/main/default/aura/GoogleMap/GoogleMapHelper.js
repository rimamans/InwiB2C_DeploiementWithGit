({
    loadGoogleMaps: function(component, event, helper) {
        console.log("Tentative de chargement de Google Maps depuis les ressources statiques");

        // Définir le nom de la fonction de callback
        const callback = "initMap"; // Définit le nom de la fonction de rappel

        // Créer le script pour charger Google Maps
        const scriptUrl = $A.get('$Resource.GoogleMapAPI'); // Assurez-vous que le nom correspond à votre ressource statique
        console.log("URL du script Google Maps :", scriptUrl);

        const script = document.createElement("script");
        script.src = `${scriptUrl}?callback=${callback}`; // Inclut le callback dans l'URL
        script.async = true;

        // Définir la fonction initMap dans l'objet window
        window.initMap = function() {
            console.log("initMap appelée");
            helper.checkGoogleMapsLoaded(component, helper);
        };
        console.log("initMap est définie dans window.");

        // Ajouter le script au DOM
        script.onload = function() {
            console.log("Script Google Maps chargé avec succès");
            console.log("Vérification de google :", window.google);
            console.log("Vérification de google.maps :", window.google.maps);
            window.initMap(); // Appeler initMap ici
        };

        script.onerror = function(error) {
            console.error("Erreur lors du chargement du script Google Maps:", error);
        };

        document.body.appendChild(script);
    },

    checkGoogleMapsLoaded: function(component, helper) {
        // Vérifie si google et google.maps sont disponibles
        if (window.google && window.google.maps) {
            console.log("Google Maps API est chargée, initialisation de la carte.");
            helper.initMap(component);
        } else {
            console.log("Google Maps API is not loaded yet. Checking again...");
            setTimeout(() => {
                helper.checkGoogleMapsLoaded(component, helper); // Vérifie à nouveau après 1 seconde
            }, 1000);
        }
    },

    initMap: function(component) {
        // Vérifie si google.maps est défini
        if (window.google && window.google.maps) {
            const mapElement = component.find("map").getElement();
            const map = new google.maps.Map(mapElement, {
                center: { lat: 48.8566, lng: 2.3522 }, // Centre sur Paris, France
                zoom: 12
            });
            console.log("Carte Google Maps initialisée");
        } else {
            console.error("Google Maps API is not loaded yet in initMap.");
        }
    }
})


// ({
//     loadGoogleMaps: function(component, event, helper) {
//         console.log("Tentative de chargement de Google Maps depuis les ressources statiques");
        
//         // Définir le nom de la fonction de callback
//         const callback = "initMap"; // Définit le nom de la fonction de rappel

//         // Créer le script pour charger Google Maps
//         const scriptUrl = $A.get('$Resource.GoogleMapAPI'); // Assurez-vous que le nom correspond à votre ressource statique
//         console.log("URL du script Google Maps :", scriptUrl);
        
//         const script = document.createElement("script");
//         script.src = `${scriptUrl}?callback=${callback}`; // Inclut le callback dans l'URL
//         script.async = true;

//         // Définir la fonction initMap dans l'objet window
//         window.initMap = function() {
//             console.log("initMap appelée");
//             // Appel à helper.initMap() à l'intérieur d'un setTimeout pour attendre que Google Maps soit prêt
//             setTimeout(() => {
//                 if (window.google && window.google.maps) {
//                     helper.initMap(component);
//                 } else {
//                     console.error("Google Maps API is not loaded yet when initMap was called.");
//                 }
//             }, 5000); // Attendre 1 seconde avant de vérifier
//         };
//         console.log("initMap est définie dans window.");

//         // Ajouter le script au DOM
//         script.onload = function() {
//             console.log("Script Google Maps chargé avec succès");
//             // Appeler initMap ici, car le script a été chargé
//             window.initMap();
//         };

//         script.onerror = function(error) {
//             console.error("Erreur lors du chargement du script Google Maps:", error);
//         };

//         document.body.appendChild(script);
//     },

//     initMap: function(component) {
//         // Vérifie si google.maps est défini
//         if (window.google && window.google.maps) {
//             const mapElement = component.find("map").getElement();
//             const map = new google.maps.Map(mapElement, {
//                 center: { lat: 48.8566, lng: 2.3522 }, // Centre sur Paris, France
//                 zoom: 12
//             });
//             console.log("Carte Google Maps initialisée");
//         } else {
//             console.error("Google Maps API is not loaded yet in initMap.");
//         }
//     }
// })

//-------------------------=======================================================================
// ({
//     loadGoogleMaps: function(component, event, helper) {
//         console.log("Tentative de chargement de Google Maps depuis les ressources statiques");
        
//         // Définir le nom de la fonction de callback
//         const callback = "initMap"; // Définit le nom de la fonction de rappel

//         // Créer le script pour charger Google Maps
//         const scriptUrl = $A.get('$Resource.GoogleMapAPI'); // Assurez-vous que le nom correspond à votre ressource statique
//         console.log("URL du script Google Maps :", scriptUrl);
        
//         const script = document.createElement("script");
//         script.src = `${scriptUrl}?callback=${callback}`; // Inclut le callback dans l'URL
//         script.async = true;

//         // Définir la fonction initMap dans l'objet window
//         window.initMap = function() {
//             console.log("initMap appelée");
//             // Attendre que l'API Google Maps soit complètement chargée
//             if (window.google && window.google.maps) {
//                 helper.initMap(component);
//             } else {
//                 console.error("Google Maps API is not loaded yet when initMap was called.");
//             }
//         };
//         console.log("initMap est définie dans window.");

//         // Ajouter le script au DOM
//         script.onload = function() {
//             console.log("Script Google Maps chargé avec succès");
//             // Appeler initMap ici pour s'assurer qu'elle est appelée après le chargement
//             // On peut l'appeler ici en toute sécurité car le script est chargé.
//             window.initMap();
//         };

//         script.onerror = function(error) {
//             console.error("Erreur lors du chargement du script Google Maps:", error);
//         };

//         document.body.appendChild(script);
//     },

//     initMap: function(component) {
//         // Vérifie si google.maps est défini
//         if (window.google && window.google.maps) {
//             const mapElement = component.find("map").getElement();
//             const map = new google.maps.Map(mapElement, {
//                 center: { lat: 48.8566, lng: 2.3522 }, // Centre sur Paris, France
//                 zoom: 12
//             });
//             console.log("Carte Google Maps initialisée");
//         } else {
//             console.error("Google Maps API is not loaded yet in initMap.");
//         }
//     }
// })
 //----------------------------------------------------------------------

// ({
//     loadGoogleMaps: function(component, event, helper) {
//         console.log("Tentative de chargement de Google Maps depuis les ressources statiques");
        
//         // Définir le nom de la fonction de callback
//         const callback = "initMap"; // Définit le nom de la fonction de rappel

//         // Créer le script pour charger Google Maps
//         const scriptUrl = $A.get('$Resource.GoogleMapAPI'); // Assurez-vous que le nom correspond à votre ressource statique
//         console.log("URL du script Google Maps :", scriptUrl);
        
//         const script = document.createElement("script");
//         script.src = `${scriptUrl}?callback=${callback}`; // Inclut le callback dans l'URL
//         script.async = true;

//         // Définir la fonction initMap dans l'objet window
//         window.initMap = function() {
//             console.log("initMap appelée");
//             helper.initMap(component);
//         };
//         console.log("initMap est définie dans window.");

//         // Ajouter le script au DOM
//         script.onload = function() {
//             console.log("Script Google Maps chargé avec succès");
//             // Appeler initMap ici pour s'assurer qu'elle est appelée après le chargement
//             if (window.initMap) {
//                 window.initMap(); // Appeler la fonction de callback manuellement
//             }
//         };

//         script.onerror = function(error) {
//             console.error("Erreur lors du chargement du script Google Maps:", error);
//         };

//         document.body.appendChild(script);
//     },

//     initMap: function(component) {
//         // Vérifie si google.maps est défini
//         if (window.google && window.google.maps) {
//             const mapElement = component.find("map").getElement();
//             const map = new google.maps.Map(mapElement, {
//                 center: { lat: 48.8566, lng: 2.3522 }, // Centre sur Paris, France
//                 zoom: 12
//             });
//             console.log("Carte Google Maps initialisée");
//         } else {
//             console.error("Google Maps API is not loaded yet.");
//         }
//     }
// })