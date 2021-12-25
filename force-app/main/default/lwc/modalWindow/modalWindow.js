import { LightningElement } from 'lwc';

export default class ModalWindow extends LightningElement {
    isModalOpen;
    isEditApiUser = false;

    openModal(event) {
        let buttonsClicked = event.target.label;
        if(buttonsClicked == 'Edit API User') {
            this.isEditApiUser = true;
        } else if (buttonsClicked == 'OAuth Setup Instructions') {
            this.isEditApiUser = false;
        }
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
    }
}