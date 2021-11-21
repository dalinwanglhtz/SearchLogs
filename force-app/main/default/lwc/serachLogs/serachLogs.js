import { LightningElement, wire } from 'lwc';
import searchLogs from '@salesforce/apex/SearchLogs.searchLogs';
import getApiUser from '@salesforce/apex/SearchLogs.getApiUser';

export default class SerachLogs extends LightningElement {
    someData;
    error;
    isLoaded = true;
    readyForSearch = false;

    connectedCallback() {
        getApiUser()
            .then((result) => {
                this.readyForSearch = result; 
            })
            .catch((error) => {
                this.error = error;
            })
    }

    handerRegisterSuccess() {
        this.readyForSearch = true;
    }

    handleEnter(event) {
        // When you hit Enter key
        if(event.keyCode == 13) {
            this.handleSearch();
        }
    }

    handleSearch() {
        this.isLoaded = false;
        let searchText = this.template.querySelector('lightning-input').value;
        if(!searchText) {
            this.isLoaded = true;
            return;
        }
        searchLogs({searchStr : searchText})
            .then((result) => {
                console.log('Got data: ', result);
                this.isLoaded = true;
                this.someData = result;
            })
            .catch((error) => {
                this.error = error;
                this.isLoaded = true;
            });
    }
}