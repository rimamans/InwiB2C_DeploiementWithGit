import { LightningElement, track } from 'lwc';

export default class AddressToMap extends LightningElement {
    @track mapMarkers = [];
    address;

    handleAddressChange(event) {
        this.address = event.target.value;
        this.geocodeAddress();
    }

    geocodeAddress() {
    const apiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
    const geocodeUrl = `https://maps.googleapis.com/maps/api/geocode/json?address=${encodeURIComponent(this.address)}&key=${apiKey}`;

    fetch(geocodeUrl)
        .then(response => {
            if (!response.ok) {
                throw new Error(`Erreur HTTP : ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            if (data.results && data.results.length > 0) {
                const location = data.results[0].geometry.location;
                this.mapMarkers = [
                    {
                        location: {
                            Latitude: location.lat,
                            Longitude: location.lng
                        },
                        title: 'Position trouvée',
                        description: this.address
                    }
                ];
            } else {
                console.warn('Aucun résultat pour cette adresse', data);
                alert('Aucun résultat trouvé pour cette adresse. Veuillez vérifier le format.');
            }
        })
        .catch(error => {
            console.error('Erreur de géocodage:', error);
            alert(`Erreur lors de la géocodage de l'adresse : ${error.message}`);
        });
}
}