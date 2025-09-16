import { LightningElement, track, api } from 'lwc';



export default class inwiB2C_AMFileData extends LightningElement {
    @track filename;

    // Gestionnaire pour l'upload de fichier
    uploadFileHandler(event) {
        const uploadedFiles = event.detail.files;

        if (uploadedFiles.length > 0) {
            // On récupère le nom du fichier chargé
            this.filename = uploadedFiles[0].name;
            console.log(`Nom du fichier uploadé : ${this.filename}`);
        } else {
            console.log("Aucun fichier n'a été uploadé.");
        }
    }

    // Fonction pour le bouton "Suivant"
    handleNext() {
        if (this.filename) {
            console.log(`Nom du fichier uploadé (dans handleNext) : ${this.filename}`);
        } else {
            console.log("Aucun fichier n'a été uploadé.");
        }
    }
}