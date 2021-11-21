import { LightningElement, wire } from 'lwc';
import searchLogs from '@salesforce/apex/SearchLogs.searchLogs';

export default class SerachLogs extends LightningElement {
    someData;
    error;
    isLoaded = true;

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
                this.isLoaded = true;
                this.someData = result;
            })
            .catch((error) => {
                this.error = error;
                this.isLoaded = true;
            });
    }
}