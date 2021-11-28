import { LightningElement } from 'lwc';

export default class ModalWindow extends LightningElement {
    isModalOpen;

    openModal() {
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
    }
}